/*
Code for reading DS Screen readings found here:
http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1243499684/2#2
Written by Robin Whitfield and originally by Marco Nicolato.

Other code written by Max Novakovic.
*/

// define the DS Screen pins
#define To 2 // Top
#define Lo 3 // Left
#define Bo 4 // Bottom
#define Ro 5 // Right

// Analog connections (used to read the touch position)
#define Ti 17 // Top
#define Ri 18 // Right

int touchX, touchY = 0; // Holds the X and Y values from touch screen

void setup()
{
  // Open serial port for serial monitor
  Serial.begin(9600);
}

void loop()
{
  
  if(touched())  //if the screen is touched then...
  {
    
    Serial.print(touchX,DEC);
    Serial.print(",");
    Serial.println(touchY,DEC);

  }
}


// Check touch screen function written by 'mowicus'
// From: http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1243499684/2#2
boolean touched()
{
  // Default return value is false
  boolean touch = false;

  // Horizontal routine - set L to gnd and R to Vcc

  // set L = ground
  pinMode(Lo, OUTPUT);
  digitalWrite(Lo, LOW);

  // set R = Vcc
  pinMode(Ro, OUTPUT);
  digitalWrite(Ro, HIGH);

  // T e B high impedance (input mode)
  pinMode(To, INPUT);
  pinMode(Bo, INPUT);

  // wait a bit, then read from Top
  delay(10);

  touchX = analogRead(Ti);


  // Vertical routine - set B to gnd and T to Vcc

  // Set B = gnd
  pinMode(Bo, OUTPUT);
  digitalWrite(Bo, LOW);

  // set T = Vcc
  pinMode(To, OUTPUT);
  digitalWrite(To, HIGH);

  // R e L high impedance (input mode)
  pinMode(Ro, INPUT);
  pinMode(Lo, INPUT);

  // wait a bit, then read from Right
  delay(10);

  touchY = analogRead(Ri);

  // Dont read certain values, this stops the screen from 
  // constantly thinking it is being read/touched
  if(touchX < 600 and touchX > 0 and touchY < 630 and touchY > 0) 
  {
    touch = true;
  }

  // Return true/false
  return touch;

}

