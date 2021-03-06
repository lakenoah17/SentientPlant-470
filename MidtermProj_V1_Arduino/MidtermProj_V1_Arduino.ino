#include <CapacitiveSensor.h>
// 50k - 50M resistor between pins 2 & 3, pin 3 is sensor (receive) pin
CapacitiveSensor sensor = CapacitiveSensor(2,3);
void setup() {
  // turn off autocalibrate on channel 1 - just as an example
  sensor.set_CS_AutocaL_Millis(0xFFFFFFFF);
  Serial.begin(9600);
}
void loop() {
  long capacitativeTotal = sensor.capacitiveSensor(30); // take 30 samples
  int photoCellVal = analogRead(A0);

  Serial.print(capacitativeTotal);     
  Serial.print('#');  
  Serial.println(photoCellVal);  
  delay(1);                                 // small delay to spare serial port from too much data
}
