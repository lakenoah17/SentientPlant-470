import processing.sound.*;
import processing.serial.*;

SoundFile sound;
Serial arduinoPort;

final int sensorPin = 0;
final int darkValToYellAt = 350;
final int touchValToYellAt = 500;
int soundCooldown = 0;
int capacitativeVal = 50;
int photoCellVal = 500;
int time = 0;
SoundFile[] darkSounds;
SoundFile[] touchSounds;
SoundFile currSound;

void setup(){
  size(800,800);
  background(255);

  // Load up sounds played in dark
  darkSounds = new SoundFile[6];
  darkSounds[0] = new SoundFile(this,"Sounds/tts/dark/ah-help.mp3");
  darkSounds[1] = new SoundFile(this,"Sounds/tts/dark/dark-things.mp3");
  darkSounds[2] = new SoundFile(this,"Sounds/tts/dark/light-curse.mp3");
  darkSounds[3] = new SoundFile(this,"Sounds/tts/dark/where-curse2.mp3");
  darkSounds[4] = new SoundFile(this,"Sounds/tts/dark/darker-curse.mp3");
  darkSounds[5] = new SoundFile(this,"Sounds/tts/dark/darker-and.mp3");
  
  // Load up sounds played when touched
  touchSounds = new SoundFile[8];
  touchSounds[0] = new SoundFile(this,"Sounds/tts/touch/grow-teeth.mp3");
  touchSounds[1] = new SoundFile(this,"Sounds/tts/touch/split-head.mp3");
  touchSounds[2] = new SoundFile(this,"Sounds/tts/touch/touch-fool.mp3");
  touchSounds[3] = new SoundFile(this,"Sounds/tts/touch/touch-threat.mp3");
  touchSounds[4] = new SoundFile(this,"Sounds/tts/misc/cursed-place.mp3");
  touchSounds[5] = new SoundFile(this,"Sounds/tts/misc/to-suffer.mp3");
  touchSounds[6] = new SoundFile(this,"Sounds/tts/misc/eat-dirt.mp3");
  touchSounds[7] = new SoundFile(this,"Sounds/tts/misc/dirt-lettuce.mp3");
  
  currSound = darkSounds[0];
  
  String portName = Serial.list()[1];
  println(portName);
  arduinoPort = new Serial(this, portName, 9600);
  arduinoPort.bufferUntil('\n');
  time = millis();
}
void draw(){
  if (!currSound.isPlaying()) {//!sound.isPlaying()) { 
    if(soundCooldown > 0) {
      soundCooldown -= millis() - time;
    }
    else if (capacitativeVal > touchValToYellAt) {
      // Play random dark sound
      int randomNum = (int)random(touchSounds.length);
      currSound = touchSounds[randomNum];
      currSound.play();
      soundCooldown = 2000;
    }
    else if (photoCellVal < darkValToYellAt) {
      // Play random dark sound
      int randomNum = (int)random(darkSounds.length);
      currSound = darkSounds[randomNum];
      currSound.play();
      soundCooldown = 2000;
    }
  }
  
  time = millis();
}
void serialEvent(Serial port) {
  // get the ASCII string:
    
    String reading = port.readStringUntil('\n');

    capacitativeVal = FormatReading(reading.split("#")[0]);
    photoCellVal = FormatReading(reading.split("#")[1]);
}

int FormatReading(String reading) {
  if (reading == null)
    return 0;
  
  // trim off any whitespace:
  reading = trim(reading);
  // convert to an int and map to the screen height:
  int val = int(reading);
  //println(sensorReading);
  val = int(map(val, 0, 1023, 0, height));
  println(val);
  return val;
}
