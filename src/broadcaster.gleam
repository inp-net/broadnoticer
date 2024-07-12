import birl
import gleam/io
import gleam/list.{fold, map}
import gleam/otp/task.{async, await}
import gleam/result

pub type Notice {
  Warning(message: String, start: birl.Time, end: birl.Time)
}

pub type Broadcaster {
  Broadcaster(name: String, run: fn(Notice) -> Result(Nil, String))
}

fn error_message(broadcaster: Broadcaster, err: String) {
  "- " <> broadcaster.name <> ": " <> err <> ";"
}

fn send(broadcaster: Broadcaster, notice: Notice) {
  async(fn() {
    io.println(
      "Sending notice to "
      <> broadcaster.name
      <> " with message "
      <> notice.message,
    )
    broadcaster.run(notice)
    |> result.map_error(error_message(broadcaster, _))
  })
}

pub fn send_all(notice: Notice, broadcasters: List(Broadcaster)) {
  broadcasters
  |> map(send(_, notice))
  |> map(await(_, 10_000))
  |> fold("", fn(errors, res) {
    case res {
      Ok(_) -> errors
      Error(msg) -> errors <> "\n" <> msg
    }
  })
}
