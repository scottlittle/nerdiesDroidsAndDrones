String getBluetoothInformation()
{
  String btInfo = "Server Running: ";
  btInfo += bt.isStarted() + "\n";
  btInfo += "Device Discoverable: "+bt.isDiscoverable() + "\n";
  btInfo += "\nConnected Devices: \n";

  ArrayList<String> devices = bt.getConnectedDeviceNames();
  for (String device: devices)
  {
    btInfo+= device+"\n";
  }
  return btInfo;
}

//Call back method to manage data received
void onBluetoothDataEvent(String who, byte[] data)
{
  if (isConfiguring)
    return;

  /*int datalength = data.length;
  int[] integerdata = new int[16];
  if (datalength == 32) {
    for (int i=0;i<16;i++) {
      integerdata[i] = (data[2*i+1]&0xFF|((data[2*i]&0xFF)<<8));  //get byte data from arduino and turn it into int
    }
  }

  if (integerdata[1] != 0)
  {
    fill(100);  //grey color backgroung
    rect(5, 55, 300, 85);  //background for voltage text
    fill(255);  //white texty
    displaydata = integerdata[1]/4095.0*5.1;  //5.1 volts reference, 4095 is the max for a 12 bit adc
    text("voltage "+ displaydata, 5, 100);
  } */
}

void onAccelerometerEvent(float x, float y, float z)
{
  accelerometerX = int(182 - (x+9.8)*10);
  accelerometerY = int((y+9.8)*10);
  accelerometerZ = int((z+9.8)*10);
}


