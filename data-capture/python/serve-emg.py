#!/usr/bin/env python

from __future__ import print_function

from gevent import monkey; monkey.patch_all()
from gevent.queue import Queue
import gevent

from ws4py.server.geventserver import WebSocketServer
from ws4py.websocket import WebSocket

import serial
import time
import random
import base64

import emg_pb2


# Buffer containing unsent ADC values.
signal = Queue()

# List of opened websocket connections.
connections = []


def record_reading_chunk(record_duration):
  start_time = time.time()
  chunk = emg_pb2.ReadingChunk()
  while (time.time() - start_time < record_duration):
    while signal.empty():
      gevent.sleep(0)

    reading = chunk.readings.add()
    (reading.timestamp, reading.value) = signal.get()

  return chunk


class EmgWebSocket(WebSocket):
  def received_message(self, message):
    decoded = base64.b64decode(message.data)
    control_msg = emg_pb2.DartToPythonMessage()
    control_msg.ParseFromString(decoded)
    if (control_msg.message_type == "StartExperiment"):
      inner_msg = msg.start
      #TODO start the experiment
    elif (control_msg.message_type == "FinishExperiment"):
      inner_msg = msg.finish
      #TODO finish the experiment
    else:
      #TODO Error

  def opened(self):
    # Register this connection.
    connections.append(self)
    print('Websocket %r opened!' % self)

  def closed(self, code, reason=None):
    if self in connections:
      connections.remove(self)
    print('Websocket %r closed!' % self)


def server(websocket_class, address=('0.0.0.0', 9001)):
  print('Starting websocket server...')
  server = WebSocketServer(address, websocket_class=websocket_class)
  server.serve_forever()


def serial_receiver():
  print('Starting serial receiver...')
  # serial_port = serial.Serial('/dev/ttyACM0', 115200)
  while True:
    try:
      value = random.randrange(0, 4095)
      # value = int(serial_port.readline())
      ts = time.time()
      if signal.qsize() >= 100:
        signal.get()
      signal.put((ts, value))
    except ValueError:
      print('invalid serial read value!')

    #TODO this should be 0 when using the serial port.
    gevent.sleep(0.00001)


def sender():
  print('Starting sender...')
  while True:
    chunk = emg_pb2.ReadingChunk()
    while len(chunk.readings) <= 100:
      # Spin while the signal queue is empty.
      while signal.empty():
        # Yield to other greenlets while waiting.
        gevent.sleep(0)

      #Save the head of the queue into the chunk.
      reading = chunk.readings.add()
      (reading.timestamp, reading.value) = signal.get()

    for connection in connections:
      # TODO switch to chunk.SerializeToString() when dart/scala can handle that as input.
      connection.send(str(chunk))

    gevent.sleep(0)


if __name__ == '__main__':
  gevent.joinall([
      gevent.spawn(server, EmgWebSocket),
      gevent.spawn(serial_receiver),
      gevent.spawn(sender)
  ])
