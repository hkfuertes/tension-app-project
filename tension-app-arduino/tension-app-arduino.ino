#include <ESP8266WiFi.h>
#include <DNSServer.h>
//https://github.com/alanswx/ESPAsyncWiFiManager#install-through-library-manager
#include <ESPAsyncWiFiManager.h>

//https://github.com/me-no-dev/ESPAsyncTCP
//https://github.com/me-no-dev/ESPAsyncWebServer
#include <ESPAsyncWebServer.h>
//https://github.com/Links2004/arduinoWebSockets --> Libreria "WebSockets (client + server)"
#include <WebSocketsServer.h>

#include <FS.h>

#include <Wire.h>
//https://github.com/sparkfun/SparkFun_MAX3010x_Sensor_Library
#include "MAX30105.h"  //MAX3010x library
#include "heartRate.h" //Heart rate calculating algorithm

MAX30105 particleSensor;
const byte RATE_SIZE = 4; //Increase this for more averaging. 4 is good.
byte rates[RATE_SIZE];    //Array of heart rates
byte rateSpot = 0;
long lastBeat = 0; //Time at which the last beat occurred
float beatsPerMinute;
int beatAvg;

char datagram[80];

WebSocketsServer webSocket = WebSocketsServer(81);

AsyncWebServer server(80);
DNSServer dns;

bool wifi = true;

void InitServer()
{

    SPIFFS.begin(); // Start the SPI Flash Files System
    //https://github.com/esp8266/arduino-esp8266fs-plugin
    server.serveStatic("/", SPIFFS, "/").setDefaultFile("index.html");

    server.begin();
    Serial.println("HTTP server started");
}

void setup()
{
    Serial.begin(115200);

    if(wifi==true){
      // Creamos una instancia de la clase WiFiManager
      AsyncWiFiManager wifiManager(&server, &dns);
  
      // Descomentar para resetear configuración
      //wifiManager.resetSettings();
  
      // Cremos AP y portal cautivo
      wifiManager.autoConnect("ESP8266Temp");
      //Serial.println("Ya estás conectado: "+ WiFi.localIP());
      webSocket.begin();
      //webSocket.onEvent(webSocketEvent);
    }

    // Initialize sensor
    particleSensor.begin(Wire, I2C_SPEED_FAST); //Use default I2C port, 400kHz speed
    particleSensor.setup();                     //Configure sensor with default settings
    particleSensor.setPulseAmplitudeRed(0x0A);  //Turn Red LED to low to indicate sensor is running

    if(wifi==true) InitServer();
}

void loop()
{
    webSocket.loop();

    long irValue = particleSensor.getIR(); 
    //Reading the IR value it will permit us to know if there's a finger on the sensor or not
    
    //Also detecting a heartbeat
    if (irValue > 7000)
    {
        //If a heart beat is detected
        if (checkForBeat(irValue) == true) 
        {
            //We sensed a beat!
            long delta = millis() - lastBeat; 
            //Measure duration between two beats
            lastBeat = millis();

            //Calculating the BPM
            beatsPerMinute = 60 / (delta / 1000.0); 

            //To calculate the average we strore some values (4) then do some math to calculate the average
            if (beatsPerMinute < 255 && beatsPerMinute > 20) 
            {
                //Store this reading in the array
                rates[rateSpot++] = (byte)beatsPerMinute;
                //Wrap variable
                rateSpot %= RATE_SIZE;                    

                //Take average of readings
                beatAvg = 0;
                for (byte x = 0; x < RATE_SIZE; x++)
                    beatAvg += rates[x];
                beatAvg /= RATE_SIZE;
            }

            sprintf(datagram, "{ \"pulse\": \"%lu\" }", beatAvg);
            if(wifi==true) webSocket.broadcastTXT(datagram);
            Serial.println(datagram);
        }
    }
}
