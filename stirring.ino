int val, x = 15, count1 = 0,rpm =0;

void setup() {
  Serial.begin(9600);
  pinMode (P1_3,INPUT);
  pinMode(P1_6,OUTPUT);
  attachInterrupt(P1_3,count,FALLING);
}

void loop() {

  val = RPMCounter();
  if (val>350 && x > 12){
    x = x - 2;
  }
  else if(val<250 && x < 253){
    x = x + 2;
  }
  Serial.print("X = ");
  Serial.println(x);

  analogWrite(P1_6,x); // analog write to the motor, hence don't need pwm
}
void count(){//count incremented everytime stirrer spins (one revolution)
  count1 = count1 + 1;
}

int RPMCounter(){
  count1 = 0;// counter reset
  delay (31);//counting the number of turns in 1 sec
  rpm = count1 *32*60;
  Serial.print("RPM = ");
  Serial.println(rpm);
  return (rpm);
}




