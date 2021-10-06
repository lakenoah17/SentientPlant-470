import processing.sound.*;
import processing.serial.*;

SoundFile sound;
Serial arduinoPort;

final int sensorPin = 0;
final int valToYellAt = 300;
int yellCooldown = 0;
int sensorReading = 500;
int time = 0;

void setup(){
  size(800,800);
  background(255);
  
  //this loads the file based on the file name
  sound = new SoundFile(this,"skullsound2.mp3");
  
  //this changes the volume level (number between 0 and 1)
  sound.amp(.5);
  
  String portName = Serial.list()[0];
  println(portName);
  arduinoPort = new Serial(this, portName, 9600);
  arduinoPort.bufferUntil('\n');
  time = millis();
}
void draw(){
  if (!sound.isPlaying()) { 
    if(yellCooldown > 0) {
      yellCooldown -= millis() - time;
    }
    else if (sensorReading < valToYellAt) {
      sound.play();
      yellCooldown = 2000;
    }
  }
  time = millis();
}
void serialEvent(Serial port) {
  // get the ASCII string:
    String inString = port.readStringUntil('\n');

    if (inString != null) {
      // trim off any whitespace:
      inString = trim(inString);
      // convert to an int and map to the screen height:
      sensorReading = int(inString);
      //println(sensorReading);
      sensorReading = int(map(sensorReading, 0, 1023, 0, height));
      println(sensorReading);
    }
}
