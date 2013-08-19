package emg

import gnu.io.CommPortIdentifier

object PortDiscoverer {
  def listPorts {
    val portEnum: java.util.Enumeration[CommPortIdentifier] = CommPortIdentifier.getPortIdentifiers.asInstanceOf[java.util.Enumeration[CommPortIdentifier]]
    while (portEnum.hasMoreElements) {
      val portId: CommPortIdentifier = portEnum.nextElement()
      println(portId.getName + " - " + getPortTypeName(portId.getPortType))
    }
  }

  def getPortTypeName(portType: Int): String = {
    portType match {
      case CommPortIdentifier.PORT_I2C => "I2C"
      case CommPortIdentifier.PORT_PARALLEL => "Parallel"
      case CommPortIdentifier.PORT_RAW => "Raw"
      case CommPortIdentifier.PORT_RS485 => "RS485"
      case CommPortIdentifier.PORT_SERIAL => "Serial"
      case _ => "unknown type"
    }
  }
}
