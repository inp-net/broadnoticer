import birl
import broadcaster.{type Notice, Warning}
import gleam/dict
import gleam/dynamic.{dict, list, string}
import gleam/io
import gleam/json
import gleam/list
import gleam/result
import utils.{env_var}

pub fn run(data: Notice) -> Result(Nil, String) {
  let Warning(message, start, end) = data

  use bot_password <- env_var("CHURROS_BOT_PASSWORD")

  io.println("churros: logging in with bot account broadnoticer")
  use token <- utils.try_ctx(
    graphql(
      "
      mutation BroadnoticerLogin($password: String!) {
        login(email: \"broadnoticer\", password: $password) {
          ...on MutationLoginSuccess {
           data { token }
          }
        }
      }
    ",
      [#("password", bot_password)],
    )
      |> utils.http_post("https://churros.inpt.fr/graphql", [])
      |> result.map(fn(resp) {
        resp
        |> json.decode(dict(
          string,
          dict(string, dict(string, dict(string, string))),
        ))
        |> result.map(fn(resp) {
          resp
          |> dict.get("data")
          |> result.unwrap(or: dict.new())
          |> dict.get("login")
          |> result.unwrap(or: dict.new())
          |> dict.get("data")
          |> result.unwrap(or: dict.new())
          |> dict.get("token")
          |> result.unwrap(or: "")
        })
        |> result.map_error(fn(_) { "could not decode JSON" })
      })
      |> result.flatten,
    "while logging in",
  )

  io.println("churros: creating announcement")

  graphql(
    "
      query BroadnoticerSend($message: String!, $start: DateTime!, $end: DateTime) {
          upsertAnnouncement(body: $message, startsAt: $start, endsAt: $end, title: \"\", warning: true) {
            __typename
          }
        }
    ",
    [
      #("message", message),
      #("start", birl.to_iso8601(start)),
      #("end", birl.to_iso8601(end)),
    ],
  )
  |> utils.http_post("https://churros.inpt.fr/graphql", [
    #("Authorization", "Bearer " <> token),
  ])
  |> result.map(fn(_) { Nil })
}

fn graphql(query: String, vars: List(#(String, String))) -> String {
  json.to_string(
    json.object([
      #("query", json.string(query)),
      #(
        "variables",
        json.object(
          vars
          |> list.map(fn(var) {
            let #(key, value) = var
            #(key, json.string(value))
          }),
        ),
      ),
    ]),
  )
}
