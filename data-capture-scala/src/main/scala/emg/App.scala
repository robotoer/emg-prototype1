package emg

import emg.websocket.WebSocketClient
import io.backchat.hookup.HookupClientConfig
import java.net.URI

object App {

  def main(args : Array[String]) {
    val wsClient = new WebSocketClient(new HookupClientConfig(uri = URI.create("ws://0.0.0.0:9001/")))
    Thread.sleep(10000)
  }
}
