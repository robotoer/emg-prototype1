#!/usr/bin/env python

import serial

import avro.ipc as ipc
import avro.protocol as protocol


PROTOCOL = protocol.parse()


if __name__ == '__main__':
  serial_port = serial.Serial('/dev/ttyACM0', 9600)
  while True:
    print serial_port.readline()
