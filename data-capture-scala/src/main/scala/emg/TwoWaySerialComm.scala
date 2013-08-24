package emg

import gnu.io.{SerialPort, CommPort, CommPortIdentifier}
import java.io.InputStream

class TwoWaySerialComm {
  var reader: SerialReader = null
  var port: SerialPort = null

  def connect(portName: String): Unit = {
    val portIdentifier: CommPortIdentifier = CommPortIdentifier.getPortIdentifier(portName)
    if (portIdentifier.isCurrentlyOwned) {
      println(s"Error: Port $portName is currently in use.")
    } else {
      val commPort: CommPort = portIdentifier.open(this.getClass.getName, 2000)
      commPort match {
        case serialPort: SerialPort => {
          port = serialPort
          serialPort.setSerialPortParams(115200, SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE)
          val in: InputStream = serialPort.getInputStream
          reader = new SerialReader(in)
          serialPort.notifyOnDataAvailable(true)
          serialPort.addEventListener(reader)
        }

        case _ => println("Error: Only serial ports are handled by this class.")
      }
    }
  }


}
