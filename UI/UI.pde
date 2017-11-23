import grafica.*;
import org.gicentre.utils.stat.*;
import processing.serial.*;

// Sketch to to draw a very simple bar chart.
// Version 1.1, 3rd November, 2013.
// Author Jo Wood.

float maxTemp = 100;
float minTemp = 0;
float upperLimitT = 100;
float lowerLimitT;
BarChart barChart;
 
// Initialises the sketch and loads data into the chart.
void setup()
{
  size(1500,800);
  
  barChart = new BarChart(this);
  barChart.setData(new float[] {69});
  
  barChart.setMinValue(minTemp);
  barChart.setMaxValue(maxTemp);
     
  barChart.showValueAxis(false);
  barChart.showCategoryAxis(false);
}
 
// Draws the chart in the sketch
void draw()
{
  background(255);
  barChart.draw(100,100,200,400);

//BAR CANVAS
  fill(255,0,0);
  noStroke();
  rect(100,(240 - upperLimitT),199,7);
  fill(100,149,237);
  noStroke();
  rect(100,440,199,7);
  noFill();
  stroke(2);
  strokeWeight(3);
  rect(100,100,200,400);
  fill(255,0,0);
  textSize(16);
  textAlign(LEFT);
  text(nf(upperLimitT,0,0),65,(250 - upperLimitT));
    
}