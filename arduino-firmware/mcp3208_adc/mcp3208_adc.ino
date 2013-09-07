// mcp3208_adc.ino
// Reads data from a MCP3208 8 channel ADC over a simple SPI bus.

#define SELPIN   52 // Selection Pin
#define DATAOUT  50 // MOSI
#define DATAIN   48 // MISO
#define SPICLOCK 46 // Clock
int readvalue;

void setup() {
  // Set pin modes.
  pinMode(SELPIN,   OUTPUT);
  pinMode(DATAOUT,  OUTPUT);
  pinMode(DATAIN,   INPUT);
  pinMode(SPICLOCK, OUTPUT);

  // Disable device to start with.
  digitalWrite(SELPIN,   HIGH);
  digitalWrite(DATAOUT,  LOW);
  digitalWrite(SPICLOCK, LOW);

  Serial.begin(115200);
}

void spi_tick() {
  digitalWrite(SPICLOCK, HIGH);
  digitalWrite(SPICLOCK, LOW);
}

// Reads the voltage from the specified channel.
int read_adc(int channel) {
  int adcvalue = 0;
  byte commandbits = B11000000; // Command bits - start, mode, chn (3), dont care (3).

  // Allow channel selection.
  commandbits |= ((channel - 1) << 3);

  // Select ADC.
  digitalWrite(SELPIN, LOW);

  // Setup read request.
  for (int i = 7; i >= 3; i--) {
    digitalWrite(DATAOUT, commandbits & 1 << i);

    // Cycle clock.
    spi_tick();
  }

  // Ignores 2 null bits.
  spi_tick();
  spi_tick();

  // Read bits from ADC.
  for (int i = 11; i >= 0; i--) {
    adcvalue += digitalRead(DATAIN) << i;

    // Cycle clock.
    spi_tick();
  }
  digitalWrite(SELPIN, HIGH); //turn off device
  return adcvalue;
}


void loop() {
  readvalue = read_adc(1);
//  Serial.print("{");
  Serial.println(readvalue, DEC);

//  Serial.print(",");
//  readvalue = read_adc(2);
//  Serial.print(readvalue, DEC);
//  Serial.print(",");
//  readvalue = read_adc(3);
//  Serial.print(readvalue, DEC);
//  Serial.print(",");
//  readvalue = read_adc(4);
//  Serial.print(readvalue, DEC);
//  Serial.println("}");
  //delay(250);
}
