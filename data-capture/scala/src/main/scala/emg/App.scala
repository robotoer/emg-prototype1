package emg

import emg.websocket.WebSocketClient
import io.backchat.hookup.HookupClientConfig
import java.net.URI
import sun.misc.BASE64Encoder

object App {

  def main(args : Array[String]) {
    val wsClient = new WebSocketClient(new HookupClientConfig(uri = URI.create("ws://0.0.0.0:9001/")))
    val gesture = Emg.GestureDesc.newBuilder()
        .setGestureName("test gesture name")
        .setForce(1.0)
        .build()
    val experimentDesc = Emg.ExperimentDesc.newBuilder()
        .setExperimentName("test experiment name")
        .setGestureDuration(2)
        .setTimeBetweenGestures(3)
        .addGestures(gesture)
        .build()
    val startMsg = Emg.StartExperiment.newBuilder()
        .setSubjectName("test subject name")
        .setTimestamp(4)
        .setExperiment(experimentDesc)
        .build()
    val msg = Emg.DartToPythonMessage.newBuilder()
        .setMessageType("StartExperiment")
        .setStart(startMsg)
        .build()
    val base64Message: String = new BASE64Encoder().encode(msg.toByteArray)
    wsClient.send(base64Message)

    val finishMsg = Emg.FinishExperiment.newBuilder()
        .setSubjectName("test subject name")
        .setTimestamp(4)
        .setSaveToKiji(false)
        .build()

    val msg2 = Emg.DartToPythonMessage.newBuilder()
        .setMessageType("FinishExperiment")
        .setFinish(finishMsg)
        .build()

    val base64FinishMessage = new BASE64Encoder().encode(msg2.toByteArray)
    wsClient.send(base64FinishMessage)

    Thread.sleep(10000)
  }
}
