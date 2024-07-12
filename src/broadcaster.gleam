import birl
import gleam/function
import gleam/list
import gleam/result

pub type Notice {
  Warning(String, birl.Time, birl.Time)
}

pub type Broadcaster =
  fn(Notice) -> Result(Nil, String)

pub fn send_all(notice: Notice, broadcasters: List(Broadcaster)) {
  result.all(list.map(broadcasters, with: function.apply1(_, notice)))
}
