#include <Servo.h> 

//Incoming serial data
int incomingByte = 0;
//Bytes number in the received send
int packet=0;
//Average value initialisation for the frame
int bytes[]={125,125,125,125,0,0,0,0,0};
//PWM 
Servo rps,lps,xFPV,yFPV,motorL,motorR; 
//Pitch servos initialisation
int rpsPos=90, lpsPos=90;
//FPV servos
int xFPVPos=90,yFPVPos=90;
//gas values
int gas = 0, gasMax= 100, gasMin= 0, gasNeutral=60;
int LX=90, LY=90, RX=90, RY=90, L1=0, L2=0, R1=0, R2=0, EMERG=0;
int emergFlag=1;

void setup() {
   //Speed transmission initialisation
   Serial.begin(57600);
   //Ports attachement initialisation
   //Pitch servos
   pinMode(7, OUTPUT);
   pinMode(6, OUTPUT);
   rps.attach(7);
   lps.attach(6);
   //FPV servos
   pinMode(9, OUTPUT);
   pinMode(10, OUTPUT);
   xFPV.attach(9);
   yFPV.attach(10);
   //Motors
   motorL.attach(12);
   motorR.attach(13);
   
   //Starting position initialisation
   //Pitch servos 
   rps.write(90);
   lps.write(90);
   //FPV servos
   xFPV.write(90);
   yFPV.write(90);
   //Motors
   motorL.write(0);
   motorR.write(0);    
}

void setPitch(int LY){
  int pos=LY;
  if(pos <= 45){
     pos=45;
  }
  else if(pos >= 135){
     pos=135; 
  }
  
  Serial.print(" - Pitch : ");
  Serial.print(pos);
  lps.write(pos); 
  rps.write(180-pos);
}

void setRoll(int LX){
   if(emergFlag==0){
      if(LX>95){
         motorL.write(gas+(((LX-90)/10)*2));
      }
      else if(LX<85){
         motorR.write(gas+(((-LX/10)+9)*2));
      }
      else{
         motorL.write(gas);
         motorR.write(gas);
      }
   
      Serial.print(" - Gas motor L : ");
      Serial.print(gas+(((LX-90)/10)*2));
      Serial.print(" - Gas motor R : ");
      Serial.println(gas+(((-LX/10)+9)*2));
   }
   else{
      Serial.print(" - Gas motor L : ");
      Serial.print(gas);
      Serial.print(" - Gas motor R : ");
      Serial.println(gas);
   }
}

void setYaw(int L1, int R1){
    if(L1 && !R1){
       lpsPos--;
       rpsPos++;
       lps.write(lpsPos--); 
       rps.write(rpsPos++);
    }
    else if(!L1 && R1){
       lpsPos++;
       rpsPos--;
       lps.write(lpsPos++); 
       rps.write(rpsPos--);
      
    }
}

void setGas(int L2, int R2){
  if(emergFlag==1){
    gas=45; //45 corresponding to 0% for my motors
  }
  else if(!L2 && R2){
    if(gas++>=gasMax){
        gas=gasMax;
     }
     else{
        gas++;
     }
  }
  else if(L2 && !R2){
     if(gas--<=gasMin){
        gas=gasMin;
     }
     else{
        gas--;
     }
  }
  else{
     if(gas<gasNeutral){
        gas++;
     }
     else if(gas>gasNeutral){
        gas--;
     }
  }
}

void setFPV(int RX, int RY){
   Serial.print("FPV X axis : ");
   Serial.print(RX);
   Serial.print(" - FPV Y axis : ");
   Serial.print(RY);
   xFPV.write(RX);
   yFPV.write(RY);
}

void deserialization(int * bytes){
   LX = bytes[0];
   LY = bytes[1];
   RX = bytes[2];
   RY = bytes[3];
   L1 = bytes[4];
   R1 = bytes[5];
   L2 = bytes[6];
   R2 = bytes[7];
   EMERG = bytes[8];
   
   if(EMERG){
      if(emergFlag==0){
         emergFlag=1;
      }
      else emergFlag=0;
   } 
   else{}
  
   setGas(L2, R2);
   setPitch(LY);
   setRoll(LX);
   setYaw(L1, R1);
   setFPV(RX,RY);   
   
}

void loop() {
   if (Serial.available() > 0) {
      incomingByte = Serial.read();
      if(incomingByte==182){
         deserialization(bytes);
         packet = 0;
      }
      else {
         bytes[packet]=incomingByte;
         packet++;
      }
   }
}
