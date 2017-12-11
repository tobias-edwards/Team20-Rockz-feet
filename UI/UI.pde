import grafica.*;
import org.gicentre.utils.stat.*;
import processing.serial.*;

/* 
To-do list:
- add text box to change the values (upper limits / lower limits
- read live data DONE but does it work?
*/
//Temperature Variables
float maxTemp = 50;
float minTemp = 0;
float tempRange = maxTemp - minTemp;

String temp;
float liveTemp;
String roundedTemp;

float upperLimitT = 35;
float lowerLimitT = 25;

//PH Variables
float maxPH = 14;
float minPH = 0;
float phRange = maxPH - minPH;

String ph;
String livePH;
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

//Line graphs
GPlot plotTemp,plotStir,plotPH;
int points = 60;
int i;
long lastMillis = 0;  
int delay = 1000;
int totalPoints = 60;
String variable;
float tempLine,phLine,stirLine;
float notnullTemp,notnullPH,notnullStir;

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

 myPort = new Serial(this,"COM4", 9600);
 myPort.bufferUntil('\n');
  
  start_button = new Button("START", ((width/2)-125), 750, 250, 80);
  graph_Temp = new Button("GRAPH", paddingXTemp+25, 600, 150, 80);
  graph_PH = new Button("GRAPH", paddingXPH+25, 600, 150, 80);
  graph_Stir = new Button("GRAPH", paddingXStir + 25, 600, 150, 80);
  return_home = new Button("HOME", ((width/2)-125), 775, 250, 80);
  
  //Bar chart for the temperature
  
  barTemp = new BarChart(this);
  
  
  barTemp.setMinValue(minTemp);
  barTemp.setMaxValue(maxTemp);
     
  barTemp.showValueAxis(false);
  barTemp.showCategoryAxis(false);
  
  //Bar chart for the PH value
  
  barPH = new BarChart(this);
  

  
  barPH.setMinValue(minPH);
  barPH.setMaxValue(maxPH);
     
  barPH.showValueAxis(false);
  barPH.showCategoryAxis(false);
  
  //Bar chart for the stiring
  
  barStir = new BarChart(this);
  
  barStir.setMinValue(minStir);
  barStir.setMaxValue(maxStir);
     
  barStir.showValueAxis(false);
  barStir.showCategoryAxis(false);
  
    //Line graph for Temperature
  
  //CREATE GRAPH POINTS FOR TEMP
  GPointsArray points1 = new GPointsArray(points);
  
  //ASSIGN INITIAL VALUES TO ALL POINTS
for (i = 0; i < points; i++) 
  {
      points1.add(i,1000);
  }
  
  //CREATE PLOT TEMP
  plotTemp = new GPlot(this);
  plotTemp.setPos(25, 100); 
  plotTemp.setDim(1150, 550); 
  //Set axes limits
  plotTemp.setXLim(0, totalPoints);
  plotTemp.setYLim(0, 100);
  //SET PLOT 1 TITLE AND AXIS LABELS
  plotTemp.setTitleText(""); 
  plotTemp.getXAxis().setAxisLabelText("Time (in seconds)");
  plotTemp.getYAxis().setAxisLabelText("Temperature (in °C)");
  //ADD THE POINTS ARRAY TO PLOT 1
  plotTemp.setPoints(points1);
  
  //Line graph for PH
  
  //CREATE GRAPH POINTS FOR TEMP
  GPointsArray points2 = new GPointsArray(points);
  
  //ASSIGN INITIAL VALUES TO ALL POINTS
for (i = 0; i < points; i++) 
  {
      points2.add(i,1000);
  }
  
  //CREATE PLOT PH
  plotPH = new GPlot(this);
  plotPH.setPos(25, 100); 
  plotPH.setDim(1150, 550); 
  //Set axes limits
  plotPH.setXLim(0, totalPoints);
  plotPH.setYLim(0, 50);
  //SET PLOT 1 TITLE AND AXIS LABELS
  plotPH.setTitleText(""); 
  plotPH.getXAxis().setAxisLabelText("Time (in seconds)");
  plotPH.getYAxis().setAxisLabelText("PH SCALE");
  //ADD THE POINTS ARRAY TO PLOT 1
  plotPH.setPoints(points2);
  
  //Line graph for Stirring
  
  //CREATE GRAPH POINTS FOR TEMP
  GPointsArray points3 = new GPointsArray(points);
  
  //ASSIGN INITIAL VALUES TO ALL POINTS
for (i = 0; i < points; i++) 
  {
      points3.add(i,5000);
  }
  
  //CREATE PLOT STIR
  plotStir = new GPlot(this);
  plotStir.setPos(25, 100); 
  plotStir.setDim(1150, 550); 
  //Set axes limits
  plotStir.setXLim(0, totalPoints);
  plotStir.setYLim(0, 1000);
  //SET PLOT 3 TITLE AND AXIS LABELS
  plotStir.setTitleText(""); 
  plotStir.getXAxis().setAxisLabelText("Time (in seconds)");
  plotStir.getYAxis().setAxisLabelText("Stirring Speed in RPM");
  //ADD THE POINTS ARRAY TO PLOT 1
  plotStir.setPoints(points3);
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
  text("BIOREACTOR CONTROL PANEL", width/2, 50);
  
  textSize(32);
  text("Temperature", 200, 135);
  text("pH", width/2 - 50, 135);
  text("Stirring", 1000, 135);
  
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
  
  //GET THE NEW VALUES FROM SERIAL INPUT
      if ( myPort.available() > 0)       //CHECKS IF DATA ARE AVAILABLE IN THE ARDUINO PORT.       
          {                                    
              variable = myPort.readStringUntil('\n'); //READS THE WHOLE LINE AND STORES IT IN temp.
                  if (variable != null)                //CHECKS IF THE INPUT IS EMPTY(null).
                  {                       
                  float f = float(variable);
                  if (f > 20 && f < 40){
                    tempLine = f;
                  }
                  }
          }
 
  liveTemp = tempLine;
  barTemp.setData(new float[] {liveTemp});
  
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
  checkData(notnullPH, lowerLimitPH, upperLimitPH);
  noFill();
  strokeWeight(3);
  rect(paddingXPH, paddingY, barWidth, barHeight);
  
  //Values for PH                 
      if ( myPort.available() > 0)       //CHECKS IF DATA ARE AVAILABLE IN THE ARDUINO PORT.       
          {                                    
              variable = myPort.readStringUntil('\n'); //READS THE WHOLE LINE AND STORES IT IN temp.
                  if (variable != null)                //CHECKS IF THE INPUT IS EMPTY(null).
                  {                       
                  float f = float(variable);
                  if (f >= 3 && f <= 7) {
                     phLine = f;
                  }
                  }
          }
                 
  notnullPH = phLine;
  barPH.setData(new float[] {notnullPH});
                  
  
  // Upper limit and lower limit text
  fill(255,0,0);
  textSize(16);
  textAlign(RIGHT);
  limitText(upperLimitPH, paddingXPH, minPH, phRange);
  fill(100,149,237);
  limitText(lowerLimitPH, paddingXPH, minPH, phRange);
  
  //BOX NEXT TO GRAPH SHOWING LIVE LIGHT LEVELS
  roundedPH = String.format("%.2f",notnullPH);   //ROUNDS THE VALUE FOR ILLUMINANCE TO 0 DECIMAL PLACES.
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
  
  //GET THE NEW VALUES FROM SERIAL INPUT

  if ( myPort.available() > 0)       //CHECKS IF DATA ARE AVAILABLE IN THE ARDUINO PORT.       
          {                                    
              variable = myPort.readStringUntil('\n'); //READS THE WHOLE LINE AND STORES IT IN temp.
                  if (variable != null)                //CHECKS IF THE INPUT IS EMPTY(null).
                  {                       
                  float f = float(variable);
                  if (f > 1000){
                    stirLine = f;
                  }
           }
          }
  liveStir = stirLine;
  barStir.setData(new float[] {liveStir});
           
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
    text("TEMPERATURE LINE GRAPH", width/2, 50);
    
  plotTemp.beginDraw();
  plotTemp.drawBackground();
  plotTemp.drawBox();
  plotTemp.drawXAxis();
  plotTemp.drawYAxis();
  plotTemp.drawTopAxis();
  plotTemp.drawRightAxis();
  plotTemp.drawTitle();
  plotTemp.setPointColor(color(0,0,255));
  plotTemp.getMainLayer().drawPoints();
  //plot.drawLines();
  plotTemp.endDraw();

//CHECK IF i HAS EXCEEDED THE X AXIS LIMIT IN ORDER TO RESET IT.
if (i > totalPoints)
  {
    i=0; //RESETS i TO ZERO.
  }

//GET THE NEW VALUE FROM SERIAL INPUT
//GET THE NEW VALUES FROM SERIAL INPUT
if ( lastMillis + delay < millis())      //IF FUNCTION USED TO IMPORT DATA AT THE SAME DELAY WITH THE ARDUINO EACH TIME.
  {                    
      if ( myPort.available() > 0)       //CHECKS IF DATA ARE AVAILABLE IN THE ARDUINO PORT.       
          {                                    
              variable = myPort.readStringUntil('\n'); //READS THE WHOLE LINE AND STORES IT IN temp.
                  if (variable != null)                //CHECKS IF THE INPUT IS EMPTY(null).
                  {                       
                  float f = float(variable);
                  if (f > 20 && f < 40){
                    tempLine = f;
                  }
   }  
  

  //ADD THE NEW POINT AT THE END OF THE ARRAY.
   i++;
  plotTemp.addPoint(i,notnullTemp);
 
  //REMOVE THE FIRST POINT TO MAKE ROOM FOR THE NEW POINT.
  plotTemp.removePoint(0);

  //INCREMENTS THE X AXIS VALUE.
  lastMillis += delay;
  } 
    
    return_home.Draw();
  } else if (display_number == 3) {
    // Display graph for pH
    // White window background
    background(255);
  
    textSize(42);
    text("PH LINE GRAPH", width/2, 50);
    
  plotPH.beginDraw();
  plotPH.drawBackground();
  plotPH.drawBox();
  plotPH.drawXAxis();
  plotPH.drawYAxis();
  plotPH.drawTopAxis();
  plotPH.drawRightAxis();
  plotPH.drawTitle();
  plotPH.setPointColor(color(0,0,255));
  plotPH.getMainLayer().drawPoints();
  //plotPH.drawLines();
  plotPH.endDraw();

//CHECK IF i HAS EXCEEDED THE X AXIS LIMIT IN ORDER TO RESET IT.
if (i > totalPoints)
  {
    i=0; //RESETS i TO ZERO.
  }

//GET THE NEW VALUES FROM SERIAL INPUT
if ( lastMillis + delay < millis())      //IF FUNCTION USED TO IMPORT DATA AT THE SAME DELAY WITH THE ARDUINO EACH TIME.
  {                    
      if ( myPort.available() > 0)       //CHECKS IF DATA ARE AVAILABLE IN THE ARDUINO PORT.       
          {                                    
              variable = myPort.readStringUntil('\n'); //READS THE WHOLE LINE AND STORES IT IN temp.
                  if (variable != null)                //CHECKS IF THE INPUT IS EMPTY(null).
                  {                       
                  float f = float(variable);
                  if (f >= 3 && f <= 7) {
                     phLine = f;
                  }

          }
   }  
  

  //ADD THE NEW POINT AT THE END OF THE ARRAY.
   i++;
  plotPH.addPoint(i,notnullPH);
 
  //REMOVE THE FIRST POINT TO MAKE ROOM FOR THE NEW POINT.
  plotPH.removePoint(0);

  //INCREMENTS THE X AXIS VALUE.
  lastMillis += delay;
  }
    return_home.Draw();  
  } else if (display_number == 4) {
    // Display graph for stirring
    // White window background
    background(255);
    
    textSize(42);
    text("STIRRING LINE GRAPH", width/2, 50);
    
  plotStir.beginDraw();
  plotStir.drawBackground();
  plotStir.drawBox();
  plotStir.drawXAxis();
  plotStir.drawYAxis();
  plotStir.drawTopAxis();
  plotStir.drawRightAxis();
  plotStir.drawTitle();
  plotStir.setPointColor(color(0,0,255));
  plotStir.getMainLayer().drawPoints();
  //plot.drawLines();
  plotStir.endDraw();

//CHECK IF i HAS EXCEEDED THE X AXIS LIMIT IN ORDER TO RESET IT.
if (i > totalPoints)
  {
    i=0; //RESETS i TO ZERO.
  }

//GET THE NEW VALUES FROM SERIAL INPUT
if ( lastMillis + delay < millis())      //IF FUNCTION USED TO IMPORT DATA AT THE SAME DELAY WITH THE ARDUINO EACH TIME.
  {                    
      if ( myPort.available() > 0)       //CHECKS IF DATA ARE AVAILABLE IN THE ARDUINO PORT.       
          {                                    
              variable = myPort.readStringUntil('\n'); //READS THE WHOLE LINE AND STORES IT IN temp.
                  if (variable != null)                //CHECKS IF THE INPUT IS EMPTY(null).
                  {                       
                  float f = float(variable);
                  if (f > 1000){
                    stirLine = f;
                  }
           }
 
 }  
  //ADD THE NEW POINT AT THE END OF THE ARRAY.
   i++;
  plotStir.addPoint(i,notnullStir);
 
  //REMOVE THE FIRST POINT TO MAKE ROOM FOR THE NEW POINT.
  plotStir.removePoint(0);

  //INCREMENTS THE X AXIS VALUE.
  lastMillis += delay;
  } 
    
    return_home.Draw();
  }
  }
}

void mousePressed()
{
  if (start_button.MouseIsOver()) {
    clk++;
    if(clk % 2 == 0) 
    {
      start_button.label = "START";
      myPort.write('1'); 
    } 
    else 
    {
      start_button.label = "STOP";
      myPort.write(0); 
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