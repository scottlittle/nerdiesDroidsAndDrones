//Scott Little, Nerdies Droids and Drones, 2014, GNU GPL v3
//Built upon Ketai Library and bluetooth example by Daniel Sauter, GNU GPL v3

import android.view.WindowManager;
import android.view.View;
import android.content.Intent;
import android.os.Bundle;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;
import oscP5.*;
import java.nio.*;
import ketai.sensors.*;

KetaiSensor sensor;
KetaiBluetooth bt;
String info = "";
KetaiList klist;
PVector remoteMouse = new PVector();
//HScrollbar hs1;  // one scrollbar

ArrayList<String> devicesDiscovered = new ArrayList();
boolean isConfiguring = true;
String UIText;
float displaydata = 0;
float olddisplaydata = 0;
float xDisplay = 0;
float oldxDisplay = 0;
float zoomY = 1;
float offsetY = 0;
byte[] bytes; //global for bluetooth data sent
int sendfreq = 0; //global for send freq of bluetooth data packet

int accelerometerX = 0; //globals for sensors
int accelerometerY = 0;
int accelerometerZ = 0;
//int gyroX = 0;
//int gyroY = 0;
//int gyroZ = 0;

float mx;  //globals for joystick
float my;
float yaw = 0;
float throttle = 0;
float easing = 0.1;
int radius = 50;
int edge = 130;
int inner = edge + radius;

//********************************************************************
// The following code is required to enable bluetooth at startup.
//********************************************************************
void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
  // fix so screen doesn't go to sleep when app is active
  getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}
//********************************************************************

void setup()
{   
  bytes = ByteBuffer.allocate(8).putInt(0).array();
  orientation(PORTRAIT);
  background(78, 93, 75);
  stroke(255);
  textSize(24);
  
  sensor = new KetaiSensor(this);
  sensor.start();
  //hs1 = new HScrollbar(50, height/2+8, 300, 50, 5);

  //start listening for BT connections
  bt.start();

  UIText =  "d - discover devices\n" +
    "b - make this device discoverable\n" +
    "c - connect to device\n     from discovered list.\n" +
    "p - list paired devices\n" +
    "i - Bluetooth info";
}

void draw()
{
  if (isConfiguring)
  {
    ArrayList<String> names;
    background(78, 93, 75);

    //based on last key pressed lets display
    //  appropriately
    if (key == 'i')
      info = getBluetoothInformation();
    else
    {
      if (key == 'p')
      {
        info = "Paired Devices:\n";
        names = bt.getPairedDeviceNames();
      }
      else
      {
        info = "Discovered Devices:\n";
        names = bt.getDiscoveredDeviceNames();
      }

      for (int i=0; i < names.size(); i++)
      {
        info += "["+i+"] "+names.get(i).toString() + "\n";
      }
    }
    text(UIText + "\n\n" + info, 5, 90);
  }
  else
  {
    pushStyle();
    //hs1.display();
    Joystick();
    //fill(255);
    //rect(100,150,50,50);
    //fill(0);
    //text(hs1.getPercentage(), 100, 200);


    fill(0, 255, 0);
    stroke(0, 255, 0);
   
    popStyle();
  }

  drawUI();
  
  //int percent = hs1.getPercentage();
  sendfreq++;
  if (sendfreq == 2)  //send every sendfreq-th cycle
  {
    bytes[0] = 32;  //Nerdies drone id
    bytes[1] = byte(int(throttle));
    bytes[2] = byte(accelerometerX);
    bytes[3] = byte(accelerometerY);
    bytes[4] = byte(int(yaw));
    bytes[5] = 0;
    bytes[6] = 0;
    bytes[7] = 0;

 
    byte[] dataToArduino = bytes;
    bt.broadcast(dataToArduino);
    sendfreq = 0;  //reset sendfreq
  }
  
}


