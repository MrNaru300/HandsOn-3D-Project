#include <Arduino.h>

static String Axes[5] = {"X", "Y", "Z", "-X"/*, "-Y"*/, "-Z"};

int pin = 14;

void setup() {
  Serial.begin(9600);
}

void loop() {
    String data = "";
      for (int i = 0; i <= 4; i++) {
      data+= "{" + Axes[i] + "}" + ":"+ "{" + String(analogRead(pin))+ "}"  + ":" + "{" + String(analogRead(pin+1))+ "}"  + ",";
      pin+=2;
    }
    pin = 14;
    Serial.println(data);
    delay(1);
}