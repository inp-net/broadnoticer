import birl
import broadcaster.{type Notice, Warning}
import gleam/http
import gleam/http/request
import gleam/httpc
import gleam/io
import gleam/json
import gleam/uri

pub fn gitlab(data: Notice) {
  let Warning(message, start, end) = data
  let assert Ok(gitlab_uri) =
    uri.parse("https://git.inpt.fr/api/v4/broadcast_messages")

  let assert Ok(req) = request.from_uri(gitlab_uri)

  case
    req
    |> request.set_method(http.Post)
    |> request.set_body(
      json.to_string(
        json.object([
          #("message", json.string(message)),
          #("starts_at", json.string(birl.to_iso8601(start))),
          #("ends_at", json.string(birl.to_iso8601(end))),
        ]),
      ),
    )
    |> httpc.send
  {
    Ok(response) -> {
      io.debug(response)
      Ok(Nil)
    }
    _ -> Error("woops")
  }
  // resp.status |> should.equal(200)
}
