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
import logging
import emg_pb2

# Modify this to set the logging level
logging.basicConfig(level=logging.DEBUG)

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
    (reading.timestamp, reading.emg_value) = signal.get()

  return chunk


def decode_control_msg(encoded):
  decoded = base64.b64decode(encoded)
  msg = emg_pb2.DartToPythonMessage()
  msg.ParseFromString(decoded)

  return msg


def fill_exp_instance(start):
  logging.debug("filling experiment instance")
  exp_inst = emg_pb2.ExperimentInstance()
  exp_inst.timestamp = start.timestamp
  exp_inst.subject_name = start.subject_name
  exp_inst.experiment.experiment_name = start.experiment.experiment_name
  exp_inst.experiment.gesture_duration = start.experiment.gesture_duration
  exp_inst.experiment.time_between_gestures = start.experiment.time_between_gestures
  for gesture in start.experiment.gestures:
    g = exp_inst.experiment.gestures.add()
    g = gesture

  return exp_inst

def run_experiment(start):
  logging.debug("experiment started")
  exp_desc = start.experiment
  chunks = []
  for gesture in exp_desc.gestures:
    # Sleep between gestures.
    logging.debug("sleeping for %s seconds" % exp_desc.time_between_gestures)
    time.sleep(exp_desc.time_between_gestures)
    # Collect a chunk
    logging.debug("recording for %s seconds" % exp_desc.gesture_duration)
    chunks.append(record_reading_chunk(exp_desc.gesture_duration))

  exp_inst = fill_exp_instance(start)
  for chunk in chunks:
    logging.debug("chunk added")
    c = exp_inst.reading_chunks.add()
    for reading in chunk.readings:
      r = c.readings.add()
      (r.timestamp, r.emg_value, r.force_value) = (reading.timestamp, reading.emg_value, reading.force_value)

  return exp_inst


class EmgWebSocket(WebSocket):
  def received_message(self, message):
    control_msg = decode_control_msg(message.data)
    logging.debug(control_msg)

    if (control_msg.message_type == "StartExperiment"):
      start = control_msg.start
      exp_inst = run_experiment(start)
      logging.debug(exp_inst)
      #TODO put the experiment instance somewhere that we can reference and finish it when ready
    elif (control_msg.message_type == "FinishExperiment"):
      finish = control_msg.finish
      #TODO finish the experiment

  def opened(self):
    # Register this connection.
    connections.append(self)
    print('Websocket %r opened!' % self)

  def closed(self, code, reason=None):
    # Remove this connection from connections, if it is not present, will explode.
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
      (reading.timestamp, reading.emg_value) = signal.get()

    for connection in connections:
      # TODO switch to chunk.SerializeToString() when dart/scala can handle that as input.
      connection.send(str(chunk))

    gevent.sleep(0)


if __name__ == '__main__':
  gevent.joinall([
      gevent.spawn(server, EmgWebSocket),
      gevent.spawn(serial_receiver)
     # gevent.spawn(sender)
  ])
