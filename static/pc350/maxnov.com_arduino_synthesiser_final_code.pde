/*
Code for reading DS Screen readings found here:
http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1243499684/2#2
Written by Robin Whitfield and originally by Marco Nicolato.

Tone library from: http://code.google.com/p/arduino-tone/

Other code written by Max Novakovic.
*/

// Include tone library
#include <Tone.h>
Tone speakerTone;

// define the DS Screen pins
#define To 2 // Top
#define Lo 3 // Left
#define Bo 4 // Bottom
#define Ro 5 // Right

// Analog connections (used to read the touch position)
#define Ti 17 // Top
#define Ri 18 // Right


int speakerPin = 11; // Pin that holds the speaker
int touchX, touchY = 0; // Holds the X and Y values from touch screen
boolean firstRun = 0; // Changed to 1 after first run
int minX, minY, maxX, maxY = 0; // To hold min/max values
int inputValX, inputValY = 0; // The mapped values from the touch screen

void setup()
{
  // Open serial port for serial monitor
  Serial.begin(9600);
  // Set up the tone library on the speaker pin
  speakerTone.begin(speakerPin);
}

void loop()
{
  
  if(touched())  //if the screen is touched then...
  {
    // Make sure the touch value is a positive number
    if(touchX < 0) touchX = touchX * -1;
    if(touchY < 0) touchY = touchY * -1;
    
    // Set the max/min values on first run
    if(firstRun == 0) {
      minX = touchX; minY = touchY;
      maxX = touchX; maxY = touchY;
      firstRun = 1;
    }
     
   // Change max/min values if they are higher/lower than before
   if (touchX > maxX) maxX = touchX;
   if (touchX < minX) minX = touchX;
   if (touchY > maxY) maxY = touchY;
   if (touchY < minY) minY = touchY;

    // Map the values to a value that can go in to the speaker
    inputValX = map(touchX, minX, maxX, 100, 500);
    inputValY = map(touchY, minY, maxY, 0, 1000);
    
//    // Debug: Output mapped X and Y values
//    Serial.print(inputValX,DEC);
//    Serial.print(",");
//    Serial.println(inputValY,DEC);

    // Write the tone to the speaker
    if(inputValX < 498) speakerTone.play(inputValX,inputValY);
    delay(10);
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

//  // Debug: print out X and Y values
//  Serial.print(touchX,DEC);
//  Serial.print(",");
//  Serial.println(touchY,DEC);

  // Dont read certain values, this stops the screen from 
  // constantly thinking it is being read/touched
  if(touchX < 600 and touchX > 0 and touchY < 630 and touchY > 0) 
  {
    touch = true;
  }

  // Return true/false
  return touch;

}

