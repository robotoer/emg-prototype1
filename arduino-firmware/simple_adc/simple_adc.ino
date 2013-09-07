// emg_adc.ino
// Simple firmware for the Arduino Due that reads channels using the built in analog-to-digital
// pins.

// Define constants used by this sketch.
#define SERIAL_BAUD_RATE = 9600
#define EMG_PIN_0 = 0
#define EMG_PIN_1 = 1
#define EMG_PIN_2 = 2
#define EMG_PIN_3 = 3
#define EMG_PIN_4 = 4
#define EMG_PIN_5 = 5
#define EMG_PIN_6 = 6
#define EMG_PIN_7 = 7
#define EMG_PIN_8 = 8
#define EMG_PIN_9 = 9

void setup() {
  // Initialize the serial connection.
  Serial.begin(SERIAL_BAUD_RATE);
}

void loop() {
  // Read EMG pin 0 as fast as possible.
  Serial.println(analogRead(EMG_PIN_0), DEC);
}
