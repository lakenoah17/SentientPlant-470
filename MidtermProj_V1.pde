import processing.sound.*;
import processing.serial.*;

SoundFile sound;
Serial arduinoPort;

final int sensorPin = 0;
final int valToYellAt = 300;
int yellCooldown = 0;
int sensorReading = 500;
int time = 0;
SoundFile[] darkSounds;
SoundFile[] touchSounds;

void setup(){
  size(800,800);
  background(255);

  // Load up sounds played in dark
  darkSounds = new SoundFile[6];
  darkSounds[0] = new SoundFile(this,"Sounds/dark/ah-help.mp3");
  darkSounds[1] = new SoundFile(this,"Sounds/dark/dark-things.mp3");
  darkSounds[2] = new SoundFile(this,"Sounds/dark/light-curse.mp3");
  darkSounds[3] = new SoundFile(this,"Sounds/dark/where-curse2.mp3");
  darkSounds[4] = new SoundFile(this,"Sounds/dark/darker-curse.mp3");
  darkSounds[5] = new SoundFile(this,"Sounds/dark/darker-and.mp3");
  
  // Load up sounds played when touched
  touchSounds = new SoundFile[8];
  touchSounds[0] = new SoundFile(this,"Sounds/touch/grow-teeth.mp3");
  touchSounds[1] = new SoundFile(this,"Sounds/touch/split-head.mp3");
  touchSounds[2] = new SoundFile(this,"Sounds/touch/touch-fool.mp3");
  touchSounds[3] = new SoundFile(this,"Sounds/touch/touch-threat.mp3");
  touchSounds[4] = new SoundFile(this,"Sounds/misc/cursed-place.mp3");
  touchSounds[5] = new SoundFile(this,"Sounds/misc/to-suffer.mp3");
  touchSounds[6] = new SoundFile(this,"Sounds/misc/eat-dirt.mp3");
  touchSounds[7] = new SoundFile(this,"Sounds/misc/dirt-lettuce.mp3");
  
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
      // Play random dark sound
      int randomNum = (int)random(darkSounds.length);
      darkSounds[randomNum].play();
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
