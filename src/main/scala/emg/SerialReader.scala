package emg

import gnu.io.SerialPortEvent
import gnu.io.SerialPortEventListener

import java.io._
import scala.collection.mutable

class SerialReader(in: InputStream) extends SerialPortEventListener {
  val values: mutable.Buffer[Int] = mutable.Buffer()
  var strings: List[String] = List()
  val br: BufferedReader = new BufferedReader(new InputStreamReader(in, "UTF-8"))


  def serialEvent(arg0: SerialPortEvent): Unit =  {
    var counter = 0
    var line = br.readLine()
    while (line != null && counter < 5000) {
//      println(line)
      counter += 1
      values += line.toInt
      try {
        line = br.readLine()
      } catch {
        case ioe: IOException => println("An IOException occured " + ioe.getMessage)
      }
    }
    SerialReader.counter += counter
//    var counter = 0
//    val lines = Iterator
//        .continually { br.readLine() }
//        .takeWhile { _ != null }
//        .map { counter += 1; _.toInt }
//        .toSeq
//    values ++= lines
//    SerialReader.counter += counter
  }

  def writeValuesToFile(file: File) {
    val pw: PrintWriter = new PrintWriter(new FileWriter(file))
    for (value <- values) {
      pw.println(value)
    }
    pw.flush()
    pw.close()
  }
}

object SerialReader {
  var counter: Int = 0
}
