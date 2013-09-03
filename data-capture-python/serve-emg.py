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

import emg_pb2


# Buffer containing unsent ADC values.
signal = Queue()

# List of opened websocket connections.
connections = []


class EmgWebSocket(WebSocket):
  def received_message(self, message):
    print('Received message: %r' % message)

  def opened(self):
    # Register this connection.
    connections.append(self)
    print('Websocket %r opened!' % self)

  def closed(self, code, reason=None):
    if self in connections:
      connections.remove(self)
    print('Websocket %r closed!' % self)


def serve(websocket_class, address=('0.0.0.0', 9001)):
  print('Starting websocket server...')
  server = WebSocketServer(address, websocket_class=websocket_class)
  server.serve_forever()


def serial_receive():
  print('Starting serial receiver...')
  # serial_port = serial.Serial('/dev/ttyACM0', 115200)
  while True:
    try:
      value = random.randrange(0, 4095)
      # value = int(serial_port.readline())
      ts = time.time()
      if signal.qsize() >= 4096:
        signal.get()
      signal.put((ts, value))
      # kiji_signal.put((ts, value))
    except ValueError:
      print('invalid serial read value!')

    gevent.sleep(0.00001)


def dart_sender():
  print('Starting dart sender...')
  while True:
    chunk = emg_pb2.Chunk()
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
      gevent.spawn(serve, EmgWebSocket),
      gevent.spawn(serial_receive),
      gevent.spawn(dart_sender)
  ])
