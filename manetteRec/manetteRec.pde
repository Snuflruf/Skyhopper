 //Incoming serial data
int incomingByte = 0;
//bytes number in the received send
int packet=0;
//Quantum to convert 0~255 to 0~180
//float quantum = 180.0/255.0;
int bytes[]={125,125,125,125,0,0,0,0,0};

void setup() {
        Serial.begin(57600);
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
