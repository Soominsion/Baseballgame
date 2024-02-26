import oscP5.*;
import netP5.*;
import processing.sound.*;
import processing.sound.*;

SoundFile soundFile1;
SoundFile soundFile2;

OscP5 oscP5;
OscP5 oscP5_2;
NetAddress dest;
NetAddress dest2;

float message1 = 0;  // Output for Wekinator model 1
float message2 = 0;  // Output for Wekinator model 2

boolean atBatPrinted = false;  // Flag to track whether "at bat" message has been printed
boolean pitchPrinted = false;  // Flag to track whether "at bat" message has been printed

PImage baseballImage,backimg;
float xPosition;
float yPosition;
float diameter;
float speedX;
float speedY;
boolean mouseClicked = false;
boolean spacebarPressed = false;




void setup() {
  oscP5 = new OscP5(this, 12000);
  dest = new NetAddress("127.0.0.1", 6448);

  oscP5_2 = new OscP5(this, 12001);
  dest2 = new NetAddress("127.0.0.1", 6450);
  
  size(800, 800);
  backimg = loadImage("data/background.png");
  baseballImage = loadImage("data/baseball.png");
  xPosition = width / 2;
  yPosition = 400;
  diameter = 10;
  randomizeSpeed();
  
    String filePath = "data/hit.mp3";
        String filePath2 = "data/pitch.mp3";

  
  soundFile1 = new SoundFile(this, filePath);
    soundFile2 = new SoundFile(this, filePath2);

 
 
  
  
  
}




void draw() {
  
  
  
background(220);
  image(backimg, 0,0,800, 800);
   if(checkBat()){
      soundFile1.play();
     spacebarPressed = true;
  }
  if(checkPitch()){
    //print("pitch");
       soundFile2.play();
  
     mouseClicked = true;
  }
  
    if (mouseClicked) {
    Ballcomming();
  }
   if (spacebarPressed) {
    Ballhitting();
  }
  
  
  
  
  // background(190);
 // println("Model 1: " + message1 + ", Model 2: " + message2);

  
 
    

    
    
    
    
  
}

boolean checkBat(){
   if (message1 == 2 && !atBatPrinted && message1!=0) {
    atBatPrinted = true;  // Set the flag to true to indicate the message has been printed
    
    randomizeSpeed();
    spacebarPressed = true;
    Ballhitting();
    return true;
  } else if (message1 !=2) {
    atBatPrinted = false;  // Reset the flag if the condition is no longer met
  }
  
  return false;
}

boolean checkPitch(){
  if (message2 ==2 && !pitchPrinted && message2!=0) {
    //println("pitch " + message2 );
    pitchPrinted = true;  // Set the flag to true to indicate the message has been printed
    xPosition = width / 2;
    yPosition = 400;
    diameter = 10;
    randomizeSpeed();
    mouseClicked = true;  // 클릭 시에만 이미지 표시하도록 설정
    Ballcomming();
      return true;
  } else if (message2 != 2) {
    pitchPrinted = false;  // Reset the flag if the condition is no longer met
  }
  return false;
}

// automatically called whenever osc message is received
void oscEvent(OscMessage m) {
    //m.print();
  int sourcePort = m.port();    // Check the source port of the incoming message
  println(sourcePort);
  if (sourcePort == 55877) {   // Phone 1 port : 48


      message1 = m.get(0).floatValue();
  } else if (sourcePort == 49796) { // phone 2 port : 50
      message2 = m.get(0).floatValue();
  }
}


void randomizeSpeed() {
  float angle = random( PI*0.4, PI*0.6 );  // 0부터 2π까지의 랜덤한 각도
  speedX = 14 * cos(angle);
  speedY = 14 * sin(angle);
}


void Ballcomming(){

  xPosition += speedX;
  yPosition += speedY;

  
  if (xPosition > width + diameter / 2 || xPosition < -diameter / 2 || yPosition > height + diameter / 2) {
    xPosition = width / 2;
    yPosition = 100;
    diameter = 10;
    randomizeSpeed();
    mouseClicked = false;
  }
  diameter += 2.5;

  if (mouseClicked) {
    image(baseballImage, xPosition, yPosition, diameter, diameter);
  }
}

void Ballhitting(){
  xPosition -= speedX;
  yPosition -= speedY;


  if (xPosition > width + diameter / 2 || xPosition < -diameter / 2 || yPosition < 400) {
    xPosition = width / 2;
    yPosition = 700;
    diameter = 90; 
    randomizeSpeed();
    spacebarPressed = false;
  }
  if(diameter<0){
    spacebarPressed = false;
  }
  diameter -= 2.5;

  if (spacebarPressed) {
    image(baseballImage, xPosition, yPosition, diameter, diameter);
    mouseClicked = false;
  }

}
