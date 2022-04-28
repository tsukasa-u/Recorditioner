#include "HSCDHD005A.h"
#include "HSPPAD143A.h"
#include "HSHCAL001B.h"
#include <Wire.h>
#include "I2C_Handler.h"

// Server ESP32/ESP-WROOM-32
#include <WiFi.h>
#include <ESPmDNS.h>
#include <WiFiUDP.h>
#include <WiFiClient.h>
#include <time.h>

//HSCDHD005A sens_1;
//HSPPAD143A sens_2;
HSHCAL001B sens_3;
const char ssid[] = "aterm-24a2ad-g"; // TODO
const char pass[] = "438322318cabe";  // TODO
const int port = 8080; 

//const IPAddress local_ip(192, 168, 10, 107);  //TODO
const IPAddress server_ip(192, 168, 10, 102);  //TODO
//const IPAddress subnet(255, 255, 255, 0); 

WiFiClient client;
//WiFiServer server(80);
//WiFiUDP wifiUdp;

// Function that gets current epoch time
unsigned long getTime() {
  time_t now;
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) {
    //Serial.println("Failed to obtain time");
    return(0);
  }
  time(&now);
  return now;
}

void setup() {
  // put your setup code here, to run once:
  Wire.begin();
  Serial.begin(9600);
//  
  WiFi.begin(ssid, pass);
  while (WiFi.status() != WL_CONNECTED) {
    Serial.println(WiFi.status());
    delay(500);
    Serial.println("connecting");
  }
  Serial.println(WiFi.localIP());
//  server.begin();
//  wifiUdp.begin(8000);

  sens_3.Control_State(1);

//  sens_2.Mode_Setteing(0);
////  sens_2.Sampling_rate(0b10);
  
//  sens_1.MAG.Power_Mode(1);
//  sens_1.MAG.Output_Data_Rate(1);
//  sens_1.MAG.Set_Output_Range(1);

//    sens_1.ACC.Set_Mode(0);
//    sens_1.ACC.Set_Acc_Resolution(0b101);
//    sens_1.ACC.Set_Acc_Range(0b010);
//    sens_1.ACC.Set_Sampling_rate(0b1010);
//    sens_1.ACC.Set_Mode(1);

  
//  Serial.println(sens_1.MAG.Get_Temp());
}

void sendMessage() {
  float float_data = 2.0;
  byte write_data[1024];
  byte *p = write_data;
  p = (byte *)  "rrrr";
  p += 4;
  uint32_t timetemp = getTime();;
  p = (byte *)& timetemp;
  p += 4;
  p = (byte *)& float_data;
  p += 4;
  p = (byte *)& float_data;
  Serial.printf("write\n");
  client.write(write_data, 4);
}

int readLight1() {
  return digitalRead(33)*(100000.0/3.3);
}

int readlight2() {
  return digitalRead(32)*(100000.0/3.3);
}

//void cal_acc() {
//  
//  float accx, accy, accz;
//  accx = accy = accz = 0;
//  sens_1.ACC.Get_Acc(&accx, &accy, &accz);
//  Serial.print("accx:");Serial.print(accx);
//  Serial.print(",accy:");Serial.print(accy);
//  Serial.print(",accz:");Serial.println(accz);
//}

//void cal_press() {
//  
//  uint8_t flag;
//  I2C_Read (HSPPAD143A_SLAVE_ADDRESS, 0x00, &flag, 1);
//  Serial.println(flag);
//  
//  sens_2.Temp_measure_Reg(1);
//  while(sens_2.Temp_Ready()==0){} 
//  Serial.println(sens_2.get_Temp());
//  sens_2.Press_measure_Reg(1);
//  while(sens_2.Press_Ready()==0){} 
//  Serial.println(sens_2.get_Press());
//}

void cal_humi() {
//  
//  uint8_t flag;
//  I2C_Read(HSHCAL001B_SLAVE_ADDRESS, 0x0F, &flag, 1);
//  Serial.println(flag);

  sens_3.Sensor_Detect_CMD();
//  while(sens_3.Is_Hum_Measure_End()==0) {}
  Serial.print("Hum:");
  Serial.println(sens_3.Get_Hum());
//  while(sens_3.Is_Temp_Measure_End()==0) {}
  Serial.print("Temp");
  Serial.println(sens_3.Get_Temp());
}

void loop() {
  // put your main code here, to run repeatedly:

//  WiFiClient client;

//    if (!client.connect("192.168.0.7", 8080)) {
//        Serial.println("Connection failed.");
//        Serial.println("Waiting 5 seconds before retrying...");
//        delay(5000);
//        return;
//    }

    cal_humi();

//    wifiUdp.beginPacket("192.168.0.7", 8080);
//  //payload convert to type uint8_t
//  //wifiUdp.write type uint8_t only >_<
//  //std::string str = payload;
//  //uint8_t arr[sizeof(payload)];
//  //std::copy(str.begin(), str.end(), std::begin(arr));
//  //wifiUdp.write(arr, sizeof(arr));
//  uint8_t *message = (uint8_t*)"test!\r\n";
//  wifiUdp.write(message, sizeof(message));
//  wifiUdp.endPacket();
//  for (int address = 0; address < 0x80; address++) {
//    Wire.beginTransmission(address);
//    if (Wire.endTransmission() == 0) {
//      Serial.println(address);
//    }
//  }
  delay(60*1000);
  
}
