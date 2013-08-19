package emg

import org.junit.Test
import org.junit.Assert.assertEquals
import java.io.{ByteArrayInputStream, InputStream}

class TestSerialReader {
  @Test
  def testSerialEvent {
    val stream: InputStream = new ByteArrayInputStream("239423-1".getBytes("UTF-8"))
    val reader:SerialReader = new SerialReader(stream)
    reader.serialEvent(null)
    assertEquals(List("239423-1"), reader.strings)
  }
}
