package emg

import scala.collection.mutable
import java.io.File

object App {

  def main(args : Array[String]) {
    PortDiscoverer.listPorts
    val comm: TwoWaySerialComm = new TwoWaySerialComm
    comm.connect("/dev/ttyS82")
    Thread.sleep(10000)
//    comm.reader.values.reverse.foreach((a: mutable.MutableList[Int]) => println(a.map((x: Int) => x.toChar).reverse.mkString("")))
//    println(comm.reader.chars)
    comm.port.close()
    comm.reader.writeValuesToFile(new File("/home/ajprax/vutts"))
    println(SerialReader.counter)
  }

}
