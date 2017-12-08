import grafica.*;
import org.gicentre.utils.stat.*;
import processing.serial.*;

/* 
To-do list:
- add text box to change the values
- add graph buttons & do the graphs
- read live data

*/
//Temperature Variables
float maxTemp = 100;
float minTemp = 0;
float tempRange = maxTemp - minTemp;

String temp;
float liveTemp;
String roundedTemp;

float upperLimitT = 80;
float lowerLimitT = 20;

//PH Variables
float maxPH = 14;
float minPH = 0;
float phRange = maxPH - minPH;

String ph;
float livePH;
String roundedPH;

float upperLimitPH = 10;
float lowerLimitPH = 3;

//Stiring Variables
float maxStir = 100;
float minStir = 0;
float stirRange = maxStir - minStir;

String stir;
float liveStir;
String roundedStir;

float upperLimitS = 80;
float lowerLimitS = 20;

//Bar chart properties
int barHeight = 400;
int barWidth = 200;
int limitBarHeight = 7;

int paddingXTemp = 100;
int paddingXPH = 500;
int paddingXStir = 900;

int paddingY = 180;

// Store variable for display
int display_number = 1;

//Button properties
String label;
int clk =0;

//SERIAL PORT
Serial myPort;

Button start_button;
Button graph_Temp;
Button graph_PH;
Button graph_Stir;
Button return_home;

BarChart barTemp;
BarChart barPH;
BarChart barStir;


//Class used to create START/STOP button. 
class Button {

String label;
float x;    // top left corner x position
float y;    // top left corner y position
float w;    // width of button
float h;    // height of button
  
Button(String labelB, float xpos, float ypos, float widthB, float heightB) {
  label = labelB;
  x = xpos;
  y = ypos;
  w = widthB;
  h = heightB;
}  
 void Draw() {
  fill(218);
  stroke(141);
  rect(x, y, w, h, 10);
  textSize(24);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, x + (w / 2), y + (h / 2));
}

boolean MouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
      return true;
    }
      return false;
  }
}

// Initialises the sketch and loads data into the chart.
void setup()
{
  // Window size
  size(1300,900);
  
  //Read from serial port.
  //myPort = new Serial(this,"/dev/cu.usbmodem1451", 9600);
  
  start_button = new Button("START", 575, 750, 250, 80);
  graph_Temp = new Button("GRAPH", paddingXTemp+25, 600, 150, 80);
  graph_PH = new Button("GRAPH", paddingXPH+25, 600, 150, 80);
  graph_Stir = new Button("GRAPH", paddingXStir + 25, 600, 150, 80);
  return_home = new Button("HOME", 100, 100, 250, 80);
  
  //Bar chart for the temperature
  
  barTemp = new BarChart(this);
  
  liveTemp = 40;
  barTemp.setData(new float[] {liveTemp});
  
  barTemp.setMinValue(minTemp);
  barTemp.setMaxValue(maxTemp);
     
  barTemp.showValueAxis(false);
  barTemp.showCategoryAxis(false);
  
  //Bar chart for the PH value
  
  barPH = new BarChart(this);
  
  livePH = 7;
  barPH.setData(new float[] {livePH});
  
  barPH.setMinValue(minPH);
  barPH.setMaxValue(maxPH);
     
  barPH.showValueAxis(false);
  barPH.showCategoryAxis(false);
  
  //Bar chart for the stiring
  
  barStir = new BarChart(this);
  
  liveStir = 80;
  barStir.setData(new float[] {liveStir});
  
  barStir.setMinValue(minStir);
  barStir.setMaxValue(maxStir);
     
  barStir.showValueAxis(false);
  barStir.showCategoryAxis(false);
}

float getY(float y, float min, float range) {
  float percentage = (y + min) / range;
  return barHeight * (1 - percentage);
}

void limitText(float text, int x, float min, float range) {
  text(nf(text, 0, 0), x-10, paddingY + getY(text, min, range) + 8);
}

void checkData(float liveData, float lowerLimit, float upperLimit) {
  if (liveData >= upperLimit) {
    stroke(255, 0, 0);
  } else if (liveData <= lowerLimit) {
    stroke(0, 0, 255);
  } else {
    stroke(0, 0, 0);
  }
}


// Draws the chart in the sketch
void draw()
{
if ( display_number == 1) {
  // White window background
  background(255);
  
  textSize(42);
  text("BIOREACTOR CONTROL PANEL", width/2, 30);
  
  textSize(32);
  text("Temperature", 200, 135);
  text("pH", width/2 - 50, 135);
  text("Stirring", 1000, 135);
  
  //Read data from LaunchPad
  /* if ( myPort.available() > 0)       //CHECKS IF DATA ARE AVAILABLE IN THE ARDUINO PORT.       
          {                                    
              temp = myPort.readStringUntil('\n'); //READS THE WHOLE LINE AND STORES IT IN temp.
                  if (temp != null)                //CHECKS IF THE INPUT IS EMPTY(null).
                  {                  
                      println(temp);                       //IF ITS NOT EMPYT IT PRINTS THE VALUE.
                      liveTemp = float(temp);           //CONVERTS THE INPUT FROM STRING TO A FLOAT SO THAT IT CAN BE PLOT AND STORE IT IN notnullTemp.(MAYBE CHANGE IT TO DOUBLE)
                  }
          }  
  */
  
  // Data bar
  barTemp.draw(paddingXTemp, paddingY, barWidth, barHeight);
  barPH.draw(paddingXPH, paddingY, barWidth, barHeight);
  barStir.draw(paddingXStir, paddingY, barWidth, barHeight);
  
  //Bar chart Temperature
  // Upper limit bar Temp
  fill(255,0,0);
  noStroke();
  rect(paddingXTemp, paddingY + getY(upperLimitT, minTemp, tempRange), barWidth, limitBarHeight);
  
  // Lower limit Bar
  fill(100,149,237);
  noStroke();
  rect(paddingXTemp, paddingY + getY(lowerLimitT, minTemp, tempRange), barWidth, limitBarHeight);
  
  // Bar canvas
  checkData(liveTemp, lowerLimitT, upperLimitT);
  
  noFill();
  strokeWeight(3);
  rect(paddingXTemp, paddingY, barWidth, barHeight);
  
  // Upper limit and lower limit text
  fill(255,0,0);
  textSize(16);
  textAlign(RIGHT);
  limitText(upperLimitT, paddingXTemp, minTemp, tempRange);
  fill(100,149,237);
  limitText(lowerLimitT, paddingXTemp, minTemp, tempRange);
  
  //BOX NEXT TO GRAPH SHOWING LIVE LIGHT LEVELS
  roundedTemp = String.format("%.2f",liveTemp);   //ROUNDS THE VALUE FOR ILLUMINANCE TO 0 DECIMAL PLACES.
  int rectX = paddingXTemp + barWidth + 20;
  int rectY = (paddingY + barHeight/2)-(85/2);
  fill(50);
  fill(255);
  rect(rectX, rectY,125,85,10);
  textSize(22);
  fill(0,0,0);
  textSize(20);
  text(roundedTemp+"°C",rectX + 105,rectY + 48);
  
  //Bar chart for PH
  // Upper limit bar Temp
  fill(255,0,0);
  noStroke();
  rect(paddingXPH, paddingY + getY(upperLimitPH, minPH, phRange), barWidth, limitBarHeight);
  
  // Lower limit Bar
  fill(100,149,237);
  noStroke();
  rect(paddingXPH, paddingY + getY(lowerLimitPH, minPH, phRange), barWidth, limitBarHeight);
  
  // Bar canvas
  checkData(livePH, lowerLimitPH, upperLimitPH);
  noFill();
  strokeWeight(3);
  rect(paddingXPH, paddingY, barWidth, barHeight);
  
  
  
  // Upper limit and lower limit text
  fill(255,0,0);
  textSize(16);
  textAlign(RIGHT);
  limitText(upperLimitPH, paddingXPH, minPH, phRange);
  fill(100,149,237);
  limitText(lowerLimitPH, paddingXPH, minPH, phRange);
  
  //BOX NEXT TO GRAPH SHOWING LIVE LIGHT LEVELS
  roundedPH = String.format("%.2f",livePH);   //ROUNDS THE VALUE FOR ILLUMINANCE TO 0 DECIMAL PLACES.
  int rectXph = paddingXPH + barWidth + 20;
  int rectYph = (paddingY + barHeight/2)-(85/2);
  fill(50);
  fill(255);
  rect(rectXph, rectYph,125,85,10);
  textSize(22);
  fill(0, 0, 0);
  textSize(20);
  text(roundedPH,rectXph + 90,rectYph + 48);
  
  //Bar chart for Stiring
  // Upper limit bar Temp
  fill(255,0,0);
  noStroke();
  rect(paddingXStir, paddingY + getY(upperLimitS, minStir, stirRange), barWidth, limitBarHeight);
  
  // Lower limit Bar
  fill(100,149,237);
  noStroke();
  rect(paddingXStir, paddingY + getY(lowerLimitS, minStir, stirRange), barWidth, limitBarHeight);
  
  // Bar canvas
  checkData(liveStir, lowerLimitS, upperLimitS);
  noFill();
  strokeWeight(3);
  rect(paddingXStir, paddingY, barWidth, barHeight);
  
  // Upper limit and lower limit text
  fill(255,0,0);
  textSize(16);
  textAlign(RIGHT);
  limitText(upperLimitS, paddingXStir, minStir, stirRange);
  fill(100,149,237);
  limitText(lowerLimitS, paddingXStir, minStir, stirRange);
  
  //BOX NEXT TO GRAPH SHOWING LIVE LIGHT LEVELS
  roundedStir = String.format("%.2f",liveStir);   //ROUNDS THE VALUE FOR ILLUMINANCE TO 0 DECIMAL PLACES.
  int rectXstir = paddingXStir + barWidth + 20;
  int rectYstir = (paddingY + barHeight/2)-(85/2);
  fill(50);
  fill(255);
  rect(rectXstir, rectYstir,125,85,10);
  textSize(22);
  fill(0, 0, 0);
  textSize(20);
  text(roundedStir + " rpm",rectXstir + 115,rectYstir + 48);
  
  //Button
  start_button.Draw();
  graph_Temp.Draw();
  graph_PH.Draw();
  graph_Stir.Draw();
  } else if (display_number == 2) {
    // Display graph for temperature
    // White window background
    background(255);
  
    textSize(42);
    text("BIOREACTOR CONTROL PANEL", width/2, 30);
    return_home.Draw();
    
    return_home.Draw();
  } else if (display_number == 3) {
    // Display graph for pH
    // White window background
    background(255);
  
    textSize(42);
    text("BIOREACTOR CONTROL PANEL", width/2, 30);
    return_home.Draw();  
  } else if (display_number == 4) {
    // Display graph for stirring
    
    
    // White window background
    background(255);
  
    textSize(42);
    text("BIOREACTOR CONTROL PANEL", width/2, 30);
    return_home.Draw();
  }
}

void mousePressed()
{
  if (start_button.MouseIsOver()) {
    clk++;
    if(clk % 2 == 0) 
    {
      start_button.label = "START";
      //myPort.write('1'); 
    } 
    else 
    {
      start_button.label = "STOP";
      //myPort.write(0); 
    }
  } else if (graph_Temp.MouseIsOver()) {
    display_number = 2;
  } else if (graph_PH.MouseIsOver()) {
    display_number = 3;
  } else if (graph_Stir.MouseIsOver()) {
    display_number = 4;
  } else if (return_home.MouseIsOver()) {
    display_number = 1;
  }
}