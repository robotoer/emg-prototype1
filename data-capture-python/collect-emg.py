#!/usr/bin/env python

import serial

serial_port = serial.Serial('/dev/ttyACM0', 115200)
while True:
  print serial_port.readline()
