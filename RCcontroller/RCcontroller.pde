#include <PS2X_lib.h> 
PS2X ps2x; //Initiates a pad variable

//Initiates the PS2X_lib lib variable 
int error = 0; 
byte type = 0;
byte vibrate = 0;

double quantum = 180.0/255.0; //variable needed to convert 0~255 to 0~180
int pos=0; //Angle sended to the servo

void setup(){
  Serial.begin(57600); //Speed of the transmission
  pinMode(13, OUTPUT); //"ready state" LED pin of the RC pad
  error = ps2x.config_gamepad(2,5,4,3, true, true);  //config_gamepad(clock, command, attention, data, Pressures?, Rumble?) check for error
 
  //Checking of the controller presence
  if(error == 1){
    Serial.println("No controller found");
    return;
  }  
  else
    Serial.println("Controller found");
  
  
  type = ps2x.readType(); 
  if(type == 2){
    Serial.println("Wrong controller detected");
    return;
  }
}

void frameSending(char LX, char LY, char RX, char RY, char L1, char R1, char L2, char R2, char EMERG){
  Serial.print(LX); //x axis angle (Left joystick) 
  Serial.print(LY); //y axis angle (Left joystick) 
  Serial.print(RX); //x axis angle (Right joystick) 
  Serial.print(RY); //y axis angle (Right joystick) 
  Serial.print(L1); //L1 button state
  Serial.print(R1); //R1 Button state
  Serial.print(L2); //L2 button state
  Serial.print(R2); //R2 button state
  Serial.print(EMERG); //Select button state for emergency state
  Serial.print((char)182); //End frame character
}

void loop(){
 if(error == 1) //skip loop if no controller found
   return; 
 else
   digitalWrite(12, HIGH); //Turn on the LED 
   
 if(error != 1 && error !=2) { 
    ps2x.read_gamepad(false, vibrate);          //read controller
    frameSending((quantum*ps2x.Analog(PSS_LX)),(quantum*ps2x.Analog(PSS_LY)),(quantum*ps2x.Analog(PSS_RX)),(quantum*ps2x.Analog(PSS_RY)),ps2x.Button(PSB_L1),ps2x.Button(PSB_R1),ps2x.Button(PSB_L2),ps2x.Button(PSB_R2),ps2x.Button(PSB_SELECT));   
 }
 delay(50); 
}
