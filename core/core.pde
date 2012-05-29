#include <Servo.h> 

//Incoming serial data
int incomingByte = 0;
//bytes number in the received send
int packet=0;
//Quantum to convert 0~255 to 0~180
//float quantum = 180.0/255.0;
int bytes[]={125,125,125,125,0,0,0,0,0};
Servo rps,lps,xFPV,yFPV,motorL,motorR; 
int rpsPos=90, lpsPos=90,xFPVPos=90,yFPVPos=90, gaz = 0, boot=0;
void setup() {
        Serial.begin(57600);
        rps.attach(11);
        lps.attach(10);
        rps.write(90);
        lps.write(90);
        xFPV.attach(8);
        yFPV.attach(9);
        xFPV.write(90);
        yFPV.write(90);
        motorL.attach(12);
        motorR.attach(13);
        motorL.write(0);
        motorR.write(0);    
}

int checkPos(int pos){
   if(pos<=30){
      pos=0;
   }
   else if(pos>=150){
      pos=180;
   }
   else{
      pos=pos;
   }
   
   return pos;
}

void lpsMvt(int pos){
   lps.write(pos); 
}

void rpsMvt(int pos){
   
   rps.write(pos); 
}

void xFPVMvt(int pos){
   xFPV.write(pos); 
}

void yFPVMvt(int pos){
   yFPV.write(pos); 
}

void gazUp(){
   if(gaz >= 90){
      gaz=gaz;
   }
   else{
      gaz++;
   }
   
   motorL.write(gaz);
   motorR.write(gaz);
}

void gazDown(){
   if(gaz <= 0){
      gaz=gaz;
   }
   else{
      gaz--;
   }
   
   motorL.write(gaz);
   motorR.write(gaz);
}

void gazNeutral(){
   if(gaz<0){
      gaz++; 
   }
   else if(gaz>0){
      gaz--;
   }
   else{
       gaz=gaz; 
   }
      Serial.println(gaz);
   motorL.write(gaz);
   motorR.write(gaz);
}


void deserialization(int * bytes){
   
   
   int LX = bytes[0];
   int LY = bytes[1];
   int RX = bytes[2];
   int RY = bytes[3];
   int L1 = bytes[4];
   int R1 = bytes[5];
   int L2 = bytes[6];
   int R2 = bytes[7];
   int EMERG = bytes[8];
   
   rpsMvt(checkPos(rpsPos));
   lpsMvt(checkPos(lpsPos));
   
   if(R1){
      rpsPos=((180-LY)-20);
      lpsPos=(LY-20); 
   }
   else if(L1){
      rpsPos=((180-LY)+20);
      lpsPos=(LY+20);
   }
   else{
      rpsPos=(180-LY);
      lpsPos=(LY);
   }
   
   xFPVMvt(RX);
   yFPVMvt(RY);
   
   if(L2 == 0 && R2==1){
      gazUp();
   }
   else if(L2 == 1 && R2==0){
      gazDown(); 
   }
   else{
       gazNeutral(); 
   }
   
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
