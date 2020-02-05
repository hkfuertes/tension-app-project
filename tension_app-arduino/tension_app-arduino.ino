#include <ESP8266WiFi.h>
#include <DNSServer.h>
#include <ESPAsyncWiFiManager.h>

#include <ESPAsyncWebServer.h>
#include <WebSocketsServer.h>

#include <FS.h>

#include <Wire.h>
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

void InitServer()
{

    SPIFFS.begin(); // Start the SPI Flash Files System

    server.serveStatic("/", SPIFFS, "/").setDefaultFile("index.html");

    server.begin();
    Serial.println("HTTP server started");
}

void setup()
{
    Serial.begin(115200);
    // Creamos una instancia de la clase WiFiManager
    AsyncWiFiManager wifiManager(&server, &dns);

    // Descomentar para resetear configuración
    //wifiManager.resetSettings();

    // Cremos AP y portal cautivo
    wifiManager.autoConnect("ESP8266Temp");
    //Serial.println("Ya estás conectado: "+ WiFi.localIP());
    webSocket.begin();
    //webSocket.onEvent(webSocketEvent);

    // Initialize sensor
    particleSensor.begin(Wire, I2C_SPEED_FAST); //Use default I2C port, 400kHz speed
    particleSensor.setup();                     //Configure sensor with default settings
    particleSensor.setPulseAmplitudeRed(0x0A);  //Turn Red LED to low to indicate sensor is running

    InitServer();
}

void webSocketEvent(byte num, WStype_t type, uint8_t *payload, size_t length)
{
    if (type == WStype_TEXT)
    {
        if (payload[0] == '0')
        {
            //digitalWrite(pin_led, LOW);
            Serial.println("LED=off");
        }
        else if (payload[0] == '1')
        {
            //digitalWrite(pin_led, HIGH);
            Serial.println("LED=on");
        }
    }

    else // event is not TEXT. Display the details in the serial monitor
    {
        Serial.print("WStype = ");
        Serial.println(type);
        Serial.print("WS payload = ");
        // since payload is a pointer we need to type cast to char
        for (int i = 0; i < length; i++)
        {
            Serial.print((char)payload[i]);
        }
        Serial.println();
    }
}

void loop()
{
    webSocket.loop();

    long irValue = particleSensor.getIR(); //Reading the IR value it will permit us to know if there's a finger on the sensor or not
                                           //Also detecting a heartbeat
    if (irValue > 7000)
    {
        if (checkForBeat(irValue) == true) //If a heart beat is detected
        {
            //We sensed a beat!
            long delta = millis() - lastBeat; //Measure duration between two beats
            lastBeat = millis();

            beatsPerMinute = 60 / (delta / 1000.0); //Calculating the BPM

            if (beatsPerMinute < 255 && beatsPerMinute > 20) //To calculate the average we strore some values (4) then do some math to calculate the average
            {
                rates[rateSpot++] = (byte)beatsPerMinute; //Store this reading in the array
                rateSpot %= RATE_SIZE;                    //Wrap variable

                //Take average of readings
                beatAvg = 0;
                for (byte x = 0; x < RATE_SIZE; x++)
                    beatAvg += rates[x];
                beatAvg /= RATE_SIZE;
            }

            sprintf(datagram, "{ \"pulse\": \"%lu\" }", beatAvg);
            webSocket.broadcastTXT(datagram);
            Serial.println(datagram);
        }
    }
}
