#include <SoftwareSerial.h>
//#include <SoftwareServo.h> 
#include "elapsedMillis.h"
 
SoftwareSerial bluetooth(4,2);  //TX 4, RX 2

int servLo = 1000;
int servHi = 2000;

//SoftwareServo myservo;  // servo object
//SoftwareServo myservo2;
//SoftwareServo myservo3;
//SoftwareServo myservo4;
 
int btData[8];    // variable to store the servo position 
int servodata[4];  //initialize public variable for servos
 
int interval = 20000; // In microseconds. This makes the signal cycle at 50 Hz
elapsedMicros elapsedTime; // Timer value, mutated in loop()

int throttlePin = 9;
int aileronPin = 10;
int elevatorPin = 11;
int yawPin = 6;
 
void setup() 
{ 
  bluetooth.begin(38400); //communicate with bluetooth at 9600 baud rate
  Serial.begin(9600);
  
  //myservo.attach(9);  // attaches the servo on pin 9 to the servo object 
  //myservo2.attach(10); //attaches to pin 10
  //myservo3.attach(11); //attaches to pin 11
  //myservo4.attach(6);
  
  pinMode(throttlePin, OUTPUT);
  pinMode(aileronPin, OUTPUT);
  pinMode(elevatorPin, OUTPUT);
  pinMode(yawPin, OUTPUT);
  
}
 
void loop() 
{                     
   if (bluetooth.available() == 8)  //receive bytes from Android
   {
     btData[0] = bluetooth.read();
     btData[1] = bluetooth.read();
     Serial.println(btData[1]);
     btData[2] = bluetooth.read();
     btData[3] = bluetooth.read();
     btData[4] = bluetooth.read();
     btData[5] = bluetooth.read();
     btData[6] = bluetooth.read();
     btData[7] = bluetooth.read();
     
     delay(6);  //fixes servo twitch glitch for the most part
     
     if (btData[0] == 32)  //if Nerdie drone ID ok on recieved data then update commands
     {
       servodata[0] = map(btData[1],0,246,servLo,servHi);  //throttle, pin 9
       //myservo.write(servodata);
       //servodata[1] = 196-servodata[1]; //swap alieron command for pitch control 
       servodata[1] = map(btData[2],0,196,servLo,servHi);  //x axis or pitch (aile), pin 10
       //myservo2.write(servodata);
       servodata[2] = 196-servodata[2]; //swap elevator command for roll control NOTE: wasnt aileron for roll???!!!
       servodata[2] = map(btData[3],0,196,servLo,servHi);  //y axis or roll (elev), pin 11
       //myservo3.write(servodata);
       servodata[3] = map(btData[4],50,204,servLo,servHi);  //yaw (rudder), pin 6
       //myservo4.write(servodata);
     }
     else //set all outputs to minumum
          {
       servodata[0] = servLo;  //throttle, pin 9
       //myservo.write(servodata); 
       servodata[1] = servLo;  //x axis or pitch (aile), pin 10
       //myservo2.write(servodata);
       servodata[2] = servLo;  //y axis or roll (elev), pin 11
       //myservo3.write(servodata);
       servodata[3] = servLo;  //yaw (rudder), pin 6
       //myservo4.write(servodata);
     }

       
   
   } //end reading bytes
   
   if (elapsedTime > interval) //write outputs if it's time=
   {                   
      elapsedTime = 0;    // reset the counter to 0 so the counting starts over...
    
      digitalWrite(throttlePin, HIGH);  //turn on throttle for Microsecond delay amount of time
      delayMicroseconds(servodata[0]);
      digitalWrite(throttlePin, LOW);
      
      digitalWrite(aileronPin, HIGH);
      delayMicroseconds(servodata[1]);
      digitalWrite(aileronPin, LOW);
      
      digitalWrite(elevatorPin, HIGH);
      delayMicroseconds(servodata[2]);
      digitalWrite(elevatorPin, LOW);
      
      digitalWrite(yawPin, HIGH);
      delayMicroseconds(servodata[3]);
      digitalWrite(yawPin, LOW);
      
      servodata[0] = servodata[0] - 20; //this will reduce the throttle from 100% to zero in 1 second
      constrain(servodata[0], servLo, servHi); // constrain throttle to servo output range
      
      servodata[3] = servodata[3] - 20; //this will reduce the throttle from 100% to zero in 1 second
      constrain(servodata[3], servLo, servHi); // constrain throttle to servo output range
   }  
   
   //SoftwareServo::refresh();
   
} //end loop()
