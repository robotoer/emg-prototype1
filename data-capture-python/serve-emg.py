#!/usr/bin/env python

from __future__ import print_function

from gevent import monkey; monkey.patch_all()
from gevent.queue import Queue
import gevent

from ws4py.server.geventserver import WebSocketServer
from ws4py.websocket import WebSocket

import serial

import time


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


def receive():
  print('Starting receiver...')
  # serial_port = serial.Serial('/dev/ttyACM0', 115200)
  while True:
    try:
      value = 10
      # value = int(serial_port.readline())
      ts = time.time()
      signal.put((ts, value))
    except ValueError:
      print('invalid serial read value!')

    gevent.sleep(0)


def sender():
  print('Starting sender...')
  while True:
    # Spin while the signal queue is empty.
    while signal.empty():
      # Yield to other greenlets while waiting.
      gevent.sleep(0)

    # Send the head of the queue over the websocket connection.
    value = signal.get()
    for connection in connections:
      connection.send("%.20f,%d" % value)

    gevent.sleep(0)


if __name__ == '__main__':
  gevent.joinall([
      gevent.spawn(serve, EmgWebSocket),
      gevent.spawn(receive),
      gevent.spawn(sender)
  ])
