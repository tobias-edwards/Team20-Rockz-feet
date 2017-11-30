import grafica.*;
import org.gicentre.utils.stat.*;
import processing.serial.*;

/* 
To-do list:
- create class for bar graphs
-
- read live data
- add labels and live data value text
*/

float maxTemp = 100;
float minTemp = 0;
float tempRange = maxTemp - minTemp;

float upperLimitT = 80;
float lowerLimitT = 20;

int barHeight = 400;
int barWidth = 200;
int limitBarHeight = 7;

int paddingX = 100;
int paddingY = 100;

float liveTemp;

String label;
int clk =0;

//SERIAL PORT
Serial myPort;

Button start_button;

BarChart barChart;

//Class used to create START/STOP button. 
class Button {

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
  textSize(40);
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
  size(1500,800);
  
  start_button = new Button("START", 700, 600, 150, 80);
  
  barChart = new BarChart(this);
  
  liveTemp = 69;
  barChart.setData(new float[] {69});
  
  barChart.setMinValue(minTemp);
  barChart.setMaxValue(maxTemp);
     
  barChart.showValueAxis(false);
  barChart.showCategoryAxis(false);
}

float getY(float y) {
  float percentage = (y + minTemp) / tempRange;
  return barHeight * (1 - percentage);
}

void limitText(float text) {
  text(nf(text, 0, 0), 90, paddingY + getY(text) + 8);
}

// Draws the chart in the sketch
void draw()
{
  // White window background
  background(255);

  // Data bar
  barChart.draw(paddingX, paddingY, barWidth, barHeight);

  // Upper limit bar
  fill(255,0,0);
  noStroke();
  rect(paddingX, paddingY + getY(upperLimitT), barWidth, limitBarHeight);

  // Lower limit Bar
  fill(100,149,237);
  noStroke();
  rect(paddingX, paddingY + getY(lowerLimitT), barWidth, limitBarHeight);

  // Bar canvas
  noFill();
  stroke(2);
  strokeWeight(3);
  rect(paddingX, paddingY, barWidth, barHeight);

  // Upper limit and lower limit text
  fill(255,0,0);
  textSize(16);
  textAlign(RIGHT);
  limitText(upperLimitT);
  limitText(lowerLimitT);
  
  //Button
  start_button.Draw();

}

void mousePressed()
{
  if (start_button.MouseIsOver()) {
    clk++;
    if(clk % 2 == 0) 
    {
      label = "START";
      //myPort.write('1'); 
    } 
    else 
    {
      label = "STOP";
      //myPort.write(0); 
    }
  }
}
