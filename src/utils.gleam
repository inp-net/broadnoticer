import envoy
import gleam/http
import gleam/http/request
import gleam/httpc
import gleam/result

pub fn try_ctx(
  res: Result(a, String),
  ctx: String,
  apply fun: fn(a) -> Result(b, String),
) -> Result(b, String) {
  case res {
    Ok(x) -> fun(x)
    Error(e) -> Error(ctx <> ": " <> e)
  }
}

pub fn env_var(name: String, handler) {
  result.try(
    envoy.get(name) |> result.map_error(fn(_) { "Please set " <> name }),
    handler,
  )
}

fn each(subject: a, items: List(#(k, v)), do action: fn(a, k, v) -> a) -> a {
  case items {
    [] -> subject
    [#(k, v), ..rest] -> each(action(subject, k, v), rest, action)
  }
}

pub fn http_post(body: String, url: String, headers: List(#(String, String))) {
  let assert Ok(req) = request.to(url)
  req
  |> request.set_method(http.Post)
  |> each(headers, request.set_header)
  |> request.set_body(body)
  |> httpc.send
  |> result.map(fn(resp) { resp.body })
  |> result.map_error(fn(_) {
    // TODO get the actual error (but type is "Dynamic" ??)
    "An error occured"
  })
}
// pub fn dig_dict(v: Dict(String, a), path: String) {
//   case path |> string.split(".") {
//     [] -> v
//     [fragment, ..rest] ->
//       v
//       |> dict.get(fragment)
//       |> result.unwrap(dict.new())
//       |> dig_dict(string.join(rest, "."))
//   }
// }
