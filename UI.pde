import grafica.*;
import org.gicentre.utils.stat.*;
import processing.serial.*;

// Sketch to to draw a very simple bar chart.
// Version 1.1, 3rd November, 2013.
// Author Jo Wood.
 
BarChart barChart;
 
// Initialises the sketch and loads data into the chart.
void setup()
{
  size(1500,800);
  
  barChart = new BarChart(this);
  barChart.setData(new float[] {0.872});
  
  barChart.setMinValue(0);
  barChart.setMaxValue(10);
     
  barChart.showValueAxis(false);
  barChart.showCategoryAxis(false);
}
 
// Draws the chart in the sketch
void draw()
{
  background(255);
  rect(100,100,200,400);
  barChart.draw(100,100,200,400);
  
  
}