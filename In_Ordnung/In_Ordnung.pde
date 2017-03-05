/*

In Ordnung. A try on reproducing
FRIEDER NAKE
6/7/64 Nr. 20 Zufälliger Polygonzug

and tidying it up.

By LARA STUMPF

*/

// PERSONALITY OF THE PICTURE
int frame = 200; // lines don’t touch the frame

int minLines = 100;
int maxLines = 150;
int howMany = int(random(minLines, maxLines)); // number of lines

float minAngle = random(0, 360); 
float maxAngle = minAngle + random(0, 40); // range of angles 
int howManyTriesWithAngleAllowed = int(random(0, 30)); // how many tries for combining angle+length

float minLength = random(100, 500);
float maxLength = random(minLength, 1000); // length of lines

// TIDY PERSONALITY
float pointX, pointY; // splitting point-coordinates and mixing them with new ones
float lengthFrame = frame*1.5; // frame for displaying lengths
boolean left, top, right, bottom; // new position for the lengths
float lengthX, lengthY; // new coordinates for the lengths
float lengthSpace; // how much space for one length
float angleX, angleY; // position for displaying angles
float angleLength; // length for lines on angleflower

// VISUAL
color cBackground = color(255, 255, 255);
color cStroke = color(0, 0, 0);
int wStroke = 5;

// LINE STORAGE
float[] xF = new float[howMany]; // x-coordinate for each line
float[] yF = new float[howMany]; // y-coordinate for each line
float[] angleF = new float[howMany]; // angle of each line
float[] lengthF = new float[howMany]; // length of each line

void setup()
{
  size(1700,2400);
  
  stroke(cStroke);
  strokeWeight(wStroke);
  strokeCap(PROJECT);
  noFill();
  
  // STEP 1
  // RECREATING FRIEDER’S CHAOS
  
  // the first line, add random (within boundaries) elements to array
  xF[0] = random(frame, width-1-frame);
  yF[0] = random(frame, height-1-frame);
  angleF[0] = random(minAngle, maxAngle);
  lengthF[0] = random(minLength, maxLength);
  
  // the next lines
  for (int i = 1; i < howMany; i++)
  { 
    int howManyTriesWithAngle = 0; // reset for every line
   
    // while the calculated point is not inside the picture: try again
    while (xF[i] <= frame || xF[i] >= width-1-frame || yF[i] <= frame || yF[i] >= height-1-frame)
    {     
      lengthF[i] = random(minLength, maxLength); // new length
      angleF[i] = angleF[i-1] + random(minAngle, maxAngle); // add new to old angle
      
      // maybe the angles and lengths don’t work together on the current position
      // after a few tries completely dismiss our set boundaries
      if (howManyTriesWithAngle >= howManyTriesWithAngleAllowed)
      {
        angleF[i] = random(0, 360);
      }
      
      // calculate current point
      xF[i] = xF[i-1] + cos(radians(angleF[i])) * lengthF[i];
      yF[i] = yF[i-1] - sin(radians(angleF[i])) * lengthF[i];
      
      howManyTriesWithAngle++;
    }
  
    // cleaning angles over 360 degrees
    if (angleF[i] > 360)
    {
      angleF[i] = angleF[i] - 360;
    }
  }
  
  // STEP 2
  // LARA TIDYING UP
  
  // POINTS
  // splitting points and deciding about left/right and up/down
  if (howMany % 2 == 0) // left/right depending on even/uneven of howMany
  { 
    pointX = frame;
  }
  else
  {
    pointX = width-1-frame;
  }
  if (sin(howMany) >= 0) // up/down depending on pos/neg sin of howMany
  { 
    pointY = frame;
  }
  else
  {
    pointY = height-1-frame;
  }
  
  // LENGTHS
  // deciding about the new positions and calculating the space between lines
  // compare length of first old line to possible lengths (is it a quarter? and so on)
  if (lengthF[0] < ((maxLength-minLength)/4) + minLength) // < 1/4
  { 
    left = true;
    lengthX = lengthFrame;
    lengthSpace = (height - 2*lengthFrame) / float(howMany-1);
  }
  else if (lengthF[0] < ((maxLength-minLength)/2) + minLength) // < 1/2
  {
    top = true;
    lengthY = lengthFrame;
    lengthSpace = (width - 2*lengthFrame) / float(howMany-1);
  }
  else if (lengthF[0] < ((maxLength-minLength)*3/4) + minLength) // < 3/4
  {
    right = true;
    lengthX = width-1-lengthFrame;
    lengthSpace = (height - 2*lengthFrame) / float(howMany-1);
  }
  else // <= 1
  {
    bottom = true;
    lengthY = height-1-lengthFrame;
    lengthSpace = (width - 2*lengthFrame) / float(howMany-1);
  }
  // sorting the lines and reversing if the first length is an uneven number
  lengthF = sort(lengthF);
  if (lengthF[0] % 2 != 0)
  {
    lengthF = reverse(lengthF);
  }

  // ANGLE
  // put angleflower onto beginning or ending of Friederline?
  if (sin(angleF[0]) >= 0)  // depending on pos/neg sin of first angle
  {
    angleX = xF[0];
    angleY = yF[0];
  }
  else
  { 
    angleX = xF[howMany-1];
    angleY = yF[howMany-1];
  }
  // length of the lines
  angleLength = angleF[0];
  // tidying up (even though, yes, there is no visual difference) 
  angleF = sort(angleF);
}

void draw()
{
  background(255);
  
  // DRAW FRIEDER
  // draw the lines
  for (int i = 1; i < howMany; i++)
  {
    line(xF[i-1], yF[i-1], xF[i], yF[i]);
  }
  
  // DRAW LARA
  for (int i = 0; i < howMany; i++)
  {
    // POINTS
    point(pointX, yF[i]);
    point(xF[i], pointY);
    
    // LENGTHS
    if (left == true)
    {
      line(lengthX, lengthFrame + lengthSpace*i, lengthX + lengthF[i], lengthFrame + lengthSpace*i);
    }
    else if (top == true)
    {
      line(lengthFrame + lengthSpace*i, lengthY, lengthFrame + lengthSpace*i, lengthY + lengthF[i]);
    }
    else if (right == true)
    {
      line(lengthX, lengthFrame + lengthSpace*i, lengthX - lengthF[i], lengthFrame + lengthSpace*i); 
    }
    else if (bottom == true)
    {
      line(lengthFrame + lengthSpace*i, lengthY, lengthFrame + lengthSpace*i, lengthY - lengthF[i]);
    }
    
    // ANGLES
    line(angleX, angleY, angleX + cos(radians(angleF[i])) * angleLength, angleY - sin(radians(angleF[i])) * angleLength); 
  }

  // but never forget the Friederline
  line(xF[howMany-1], yF[howMany-1], xF[0], yF[0]);
  
  save("In_Ordnung.tiff"); 
}