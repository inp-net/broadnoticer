import birl
import broadcaster.{Broadcaster, Warning, send_all}
import churros
import gitlab
import gleam/io

pub fn main() {
  let notice = Warning("test", birl.now(), birl.now())

  case send_all(notice, broadcasters()) {
    "" -> io.println("All ok!")
    msg -> io.println("\nSome broadcasters failed:" <> msg)
  }
}

pub fn broadcasters() {
  [Broadcaster("Gitlab", gitlab.run), Broadcaster("Churros", churros.run)]
}
