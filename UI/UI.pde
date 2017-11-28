import grafica.*;
import org.gicentre.utils.stat.*;
import processing.serial.*;

/* 
To-do list:
- create class for bar graphs
- add button
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

BarChart barChart;
 
// Initialises the sketch and loads data into the chart.
void setup()
{
  // Window size
  size(1500,800);
  
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
}