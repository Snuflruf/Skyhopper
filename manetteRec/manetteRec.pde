#include <PS2X_lib.h>  //for v1.6
#include <Servo.h> 
//PS2X ps2x; // create PS2 Controller Class
//Servo myservo;
//byte vibrate = 0;
//double quantum = 180.0/255.0,pos=0;
int incomingByte;

void setup(){
 Serial.begin(57600);
 //myservo.attach(11);
 //myservo.write(90);
}

void loop(){
  //ps2x.read_gamepad(false, vibrate);          //read controller and set large motor to spin at 'vibrate' speed   
  if (Serial.available() > 0) {
    incomingByte = Serial.read();
    Serial.print("I received: ");
    Serial.println(incomingByte);
  } 
  /*if(ps2x.Analog(PSS_LX)) // print stick values if either is TRUE
  {
    pos=quantum*ps2x.Analog(PSS_LX);
    Serial.println(pos);   
    myservo.write(180);
  } */ 
  delay(50); 
}
