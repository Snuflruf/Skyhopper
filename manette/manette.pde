#include <PS2X_lib.h>  //for v1.6
#include <Servo.h> 
PS2X ps2x; // create PS2 Controller Class
Servo myservo;

//right now, the library does NOT support hot pluggable controllers, meaning 
//you must always either restart your Arduino after you conect the controller, 
//or call config_gamepad(pins) again after connecting the controller.
int error = 0; 
byte type = 0;
byte vibrate = 0;
double quantum = 180.0/255.0,pos=0;

void setup(){
 Serial.begin(57600);
 myservo.attach(11);
 myservo.write(90);
 //CHANGES for v1.6 HERE!!! **************PAY ATTENTION*************
  
 error = ps2x.config_gamepad(2,5,4,3, true, true);   //setup pins and settings:  GamePad(clock, command, attention, data, Pressures?, Rumble?) check for error
 
 if(error == 0){
   Serial.println("Found Controller, configured successful");
 }
   
  else if(error == 1)
   Serial.println("No controller found");
   
  else if(error == 2)
   Serial.println("Controller found but not accepting commands");
   
  else if(error == 3)
   Serial.println("Controller refusing to enter Pressures mode, may not support it. ");
   
   //Serial.print(ps2x.Analog(1), HEX);
   
   type = ps2x.readType(); 
     switch(type) {
       case 0:
        Serial.println("Unknown Controller type");
       break;
       case 1:
        Serial.println("DualShock Controller Found");
       break;
       case 2:
        Serial.println("GuitarHero Controller Found");
       break;
     }
  
}

void serialization(char LX, char LY){
   Serial.print(LX);
   Serial.print(LY); 
}

void loop(){

   
 if(error == 1) //skip loop if no controller found
  return; 
  
 if(error != 1 && error !=2) { 
    ps2x.read_gamepad(false, vibrate);          //read controller and set large motor to spin at 'vibrate' speed    
    if(ps2x.Analog(PSS_LX) || ps2x.Analog(PSS_LY)) // print stick values if either is TRUE
    {
        //pos=quantum*ps2x.Analog(PSS_LX);
        serialization(ps2x.Analog(PSS_LX),ps2x.Analog(PSS_LY));   
        //myservo.write(pos);
    }  
 }
 delay(50); 
}
