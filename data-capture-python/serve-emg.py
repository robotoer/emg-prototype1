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


# Buffer containing unsent ADC values.
signal = Queue()
# Copy of the signal queue for use by kiji_sender.
kiji_signal = Queue()

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
      kiji_signal.put((ts, value))
    except ValueError:
      print('invalid serial read value!')

    gevent.sleep(0.00001)


def dart_sender():
  print('Starting dart sender...')
  while True:
    buffered_signal = []
    while len(buffered_signal) < 100:
      # Spin while the signal queue is empty.
      while signal.empty():
        # Yield to other greenlets while waiting.
        gevent.sleep(0)

      # Save the head of the queue in the local buffer.
      buffered_signal.append(signal.get())

    # Average the timestamps and values over the last 100 signals.
    out_time = 0.0
    out_value = 0
    out_string = ""
    for v in buffered_signal:
      out_time += v[0]
      out_value += v[1]
    out_string = "%.20f,%d" % (out_time / 100, out_value / 100)

    # Send the averaged values to each connected websocket.
    for connection in connections:
      connection.send(out_string)

    gevent.sleep(0)


def kiji_sender():
  print('Starting kiji sender...')
  while True:
    buffered_signal = []
    while len(buffered_signal) < 115200:
      # Spin while the signal queue is empty.
      while kiji_signal.empty():
        # Yield to other greenlets while waiting.
        gevent.sleep(0)

      # Save t he head of the queue in the local buffer.
      buffered_signal.append(kiji_signal.get())

    # Make a call to KijiREST to store these values.


if __name__ == '__main__':
  gevent.joinall([
      gevent.spawn(serve, EmgWebSocket),
      gevent.spawn(serial_receive),
      gevent.spawn(dart_sender),
      gevent.spawn(kiji_sender)
  ])
