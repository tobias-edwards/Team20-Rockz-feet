//Code for Eng101 IEP Project 2
//Duncan Rowe, 24/11/17

#include <math.h>
//Variables for calculating temperature, taken inspiration from http://www.circuitbasics.com/arduino-thermistor-temperature-sensor-tutorial/
int thermistorPin = A3;
int voltageOutput;
float fixedResistor = 10000;
float logRestistor2, resistor2, T;
float c1 = 1.009249522e-03, c2 = 2.378405444e-04, c3 = 2.019202697e-07;

void setup() {

Serial.begin(9600);

}

void loop() {

  //Calculating temperature from the thermistor, taken inspiration from http://www.circuitbasics.com/arduino-thermistor-temperature-sensor-tutorial/
  voltageOutput = analogRead(thermistorPin)-200;
  resistor2 = fixedResistor * (1023.0 / (float)voltageOutput - 1.0);
  logRestistor2 = log(resistor2);
  float kelvin = (1.0 / (c1 + c2*logRestistor2 + c3*logRestistor2*logRestistor2*logRestistor2)); // Steinhart and Hart Equation. T  = 1 / {A + B[ln(R)] + C[ln(R)]^3}
  
  Serial.println(kelvin);
  delay(1500);

}
