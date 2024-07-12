import birl
import broadcaster.{Warning, send_all}
import gitlab.{gitlab}
import gleam/io

pub fn main() {
  case send_all(Warning("test", birl.now(), birl.now()), [gitlab]) {
    Error(msg) -> io.println("oops: " <> msg)
    Ok(_) -> Nil
  }
}
