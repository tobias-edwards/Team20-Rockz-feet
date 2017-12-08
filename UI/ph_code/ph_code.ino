#define phProbe P1_4
#define acidPump P1_3
#define basePump P1_5
#define timeInterval 1000
int lowerBound = 0;                    // reflects the volts that 0.5 ph below target
int higherBound = 0;                  // reflects the volts that 0.5 ph above target
int offsetVal = 1793;                     // need to be set
int sensitivity = 58.1;                   // need to be set
int pHbaseline = 0;                    // reflects the volts when ph is 0
int targetPH = 5;                      // need to b e set
int target = 0;                        // reflects the volts when the target ph is met
int initialTime = 0;                   // set the variable initial time


void setup() 
{
  Serial.begin(9600);               //Set the Serial port at 9600 baud rate 
  pinMode(phProbe ,INPUT);
  pinMode(acidPump ,OUTPUT);
  pinMode(basePump ,OUTPUT);
  initialTime = millis(); 
}

void loop() 
{
  defineBoundary();
  int pHval;
  int currentTime = millis();
  int pH = 3.42 * analogRead(phProbe ) + 60.8;
  pHval = (pHbaseline - pH)/sensitivity;
  Serial.println(pH);
  if(pH>higherBound)
  {
    openPump(acidPump );
    pH = 3.42 * analogRead(phProbe ) + 60.8;
    pHval = (pHbaseline - pH)/sensitivity;
    Serial.println(pHval);
  }
  else if(pH<lowerBound)
  {
    openPump(basePump );
    pH = 3.42 * analogRead(phProbe ) +60.8;
    pHval = (pHbaseline - pH)/sensitivity;
    Serial.println(pHval);
  }
  if(currentTime-initialTime > timeInterval )
  {
    if(pH>target)
    {
      openPump(acidPump );
      pH = 3.42 * analogRead(phProbe ) +60.8;
      pHval = (pHbaseline - pH)/sensitivity;
      Serial.println(pHval);
    }
    else if (pH<target)
    {
      openPump(basePump );
      pH = 3.42 * analogRead(phProbe ) +60.8;
      pHval = (pHbaseline - pH)/sensitivity;
      Serial.println(pHval);
    }
    initialTime = millis();
  }
}


void defineBoundary()
{
  pHbaseline = offsetVal + 7 * sensitivity;
  target = pHbaseline - targetPH * sensitivity;
  lowerBound = target + 0.5 * sensitivity;
  higherBound = target - 0.5 * sensitivity;
}

void openPump(int type)
{
  digitalWrite(type,HIGH);
  delay(timeInterval);
  digitalWrite(type,LOW);
}
