//Code for Eng101 IEP Project 2
//Duncan Rowe, 24/11/17

#include <math.h>


//Variables for calculating temperature, taken inspiration from http://www.circuitbasics.com/arduino-thermistor-temperature-sensor-tutorial/
int thermistorPin = P1_3;
int heaterPin = P1_4;


int voltageOutput;
float fixedResistor = 10000;
float logRestistor2, resistor2, T;
float c1 = 1.009249522e-03, c2 = 2.378405444e-04, c3 = 2.019202697e-07;

int val = 31;  

void setup() {
Serial.begin(9600);
pinMode(heaterPin, OUTPUT);          // sets the digital pin 13 as output
}

void loop() {
  //Calculating temperature from the thermistor, taken inspiration from http://www.circuitbasics.com/arduino-thermistor-temperature-sensor-tutorial/
  voltageOutput = analogRead(thermistorPin)-50;  
  //Serial.println(voltageOutput);
  resistor2 = fixedResistor * (1023.0 / (float) voltageOutput - 1.0);
  logRestistor2 = logf(resistor2);
  float kelvin = (1.0 / (c1 + c2*logRestistor2 + c3*logRestistor2*logRestistor2*logRestistor2)); // Steinhart and Hart Equation. T  = 1 / {A + B[ln(R)] + C[ln(R)]^3}
  float celcius = kelvin - 273;
  Serial.println(celcius);

  int error = val - celcius - 1;
  
  if (error > 0 ){
    int amount_heat = 20 * error;
    analogWrite(heaterPin, amount_heat);
  }  
  else{
     analogWrite(heaterPin, 0);
  }

  delay(1500);
}
