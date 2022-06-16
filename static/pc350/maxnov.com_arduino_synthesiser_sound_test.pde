int speakerPin = 11;
int r = 0;

void setup()
{
  Serial.begin(9600);
    pinMode(speakerPin, OUTPUT); 
}

void loop()
{
  // Tone
  if(r==254) { r = 0; }
  r++;
  analogWrite(speakerPin,r); 
  delay(100);
  
  
  // Random tones:
//  r = random(0,255);
//  analogWrite(speakerPin,r);
//  delay(500);
  
  
  // Static:
//  r = random(0,255);
//  analogWrite(speakerPin,r);
  
  Serial.println(r);
  
}
