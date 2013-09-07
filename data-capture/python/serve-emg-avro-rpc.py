import sys
import httplib

import avro.ipc as ipc
import avro.protocol as protocol

class UsageError(Exception):
  def __init__(self, value):
    self.value = value
  def __str__(self):
    return repr(self.value)

if (len(sys.args) != 4):
  raise UsageError("Usage: <host name> <host port> <baud rate>")

server_addr = (sys.args[1], sys.args[2])
baud_rate = sys.args[3]

with open('ath/to/avpr') as f:
  PROTOCOL = protocol.parse(f.read())

signal = Queue()
buffer = Queue()

# Moves signals into the output buffer and builds an Avro RPC every second.
def send():
  client = ipc.HTTPTransceiver(server_addr[0], serrver_addr[1])
  requestor = ipc.Requestor(PROTOCOL, client)

  while True:
    # Wait for 1 second worth of events.
    while buffer.qsize() < baud_rate:
      buffer.put(signal.get())

    # Create an RPC
    events = []
    for x in range(0, baud_rate):
      events.append(buffer.get())
    message = {'events': events}
    requestor.request('send', {'message': message})


# Populates the singal queue with values read from the serial port.
def receive():
  serial_port = serial.Serial('/dev/ttyACM0', 115200)
  while True:
    try:
      value = int(serial_port.readline())
      signal.put(value)
    except ValueError:
      print('invalid serial read value!')
