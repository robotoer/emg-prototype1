package emg

import emg.websocket.WebSocketClient
import io.backchat.hookup.HookupClientConfig
import java.net.URI
import sun.misc.BASE64Encoder

object App {

  def main(args : Array[String]) {
    val wsClient = new WebSocketClient(new HookupClientConfig(uri = URI.create("ws://0.0.0.0:9001/")))
    val msg = Emg.DartToPythonMessage.newBuilder().setMessageType("test").build()
    val base64Message: String = new BASE64Encoder().encode(msg.toByteArray)

    wsClient.send(base64Message)

    Thread.sleep(10000)
  }
}
