package emg.websocket

import io.backchat.hookup._
import io.backchat.hookup.HookupClientConfig
import io.backchat.hookup.Disconnected

class WebSocketClient(settings: HookupClientConfig)
    extends DefaultHookupClient(settings: HookupClientConfig) {

  def receive: HookupClient.Receive = {
    case Disconnected(_) => println("Websocket disconnected.")
    case TextMessage(text) => println(text)
  }

  connect() onSuccess {
    case Success => println("Websocket connected.")
  }
}
