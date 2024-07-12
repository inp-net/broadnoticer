import birl
import broadcaster.{type Notice, Warning}
import gleam/json
import gleam/result
import utils.{env_var}

pub fn run(data: Notice) -> Result(Nil, String) {
  let Warning(message, start, end) = data

  use token <- env_var("GITLAB_TOKEN")

  json.to_string(
    json.object([
      #("message", json.string(message)),
      #("starts_at", json.string(birl.to_iso8601(start))),
      #("ends_at", json.string(birl.to_iso8601(end))),
    ]),
  )
  |> utils.http_post("https://git.inpt.fr/api/v4/broadcast_message", [
    #("PRIVATE-TOKEN", token),
  ])
  |> result.map(fn(_) { Nil })
}
