/*
*  Basic Sketch to Interact with Supercollider
 *  JD Pirtle, 2012
 *  **Visual component based on classic Fading Ellipse example
 
 *  uses Andreas Schlegel's oscP5 lib for Processing
 *  http://www.sojamo.de/libraries/oscP5/index.html
 *
 *  This example demonstrates how to connect Processing 
 *  events with Supercollider (http://supercollider.sourceforge.net)
 *  using OSC (Open Sound Control, http://opensoundcontrol.org) messages sent
 *  to the Supercollider server.
 *
 *  You'll need to start the Synthdef in "basic_SC_interaction.rtf" in Supercollider
 *  before running this sketch.  
 */


//import libraries
import oscP5.*;
import netP5.*;

//create a counter that we'll use to help slow down
//communication between Processing and Supercollider (SC)
//this is a total hack, but useful here
int counter = 0;

//initialize OSC stuff
OscP5 oscP5;
int sendToPort;
int receiveAtPort;
String host;
String oscP5event;




void setup() {
  size(600, 400);
  smooth();
  noStroke();
  background(255);

  //call a funtion we'll define a bit later
  initOsc();
}

void draw() {
  fill(255, 50);
  rect(0, 0, width, height);
  fill(0);
  ellipse(mouseX, mouseY, 20, 20);

  //increment counter
  counter++;

  if (mousePressed) {
    //slow things down a bit
    if (counter%5 == 0) {
      //map mouseY to fit frequency range
      float freq = map(mouseY, 0, height, 1500, 100);
      //map mouseX to fit panning range
      float pos = map(mouseX, 0, width, -1.0, 1.0);

      //this section creates/formats/sends the OSC message to SC
      OscMessage oscMsg1 = oscP5.newMsg("/s_new");
      oscMsg1.add("withProc");
      //let SC assign a NodeID for you
      oscMsg1.add(-1);
      oscMsg1.add(0);
      oscMsg1.add(0);
      oscMsg1.add("freq");
      oscMsg1.add(freq);
      oscMsg1.add("pos");
      oscMsg1.add(pos);
      oscP5.send(oscMsg1);
    }
  }
}


//setup osc functioniality
void initOsc() {
  receiveAtPort = 12000;
  //port for supercollider server 
  sendToPort = 57110; 
  //change to whatever the IP is for the remote machine running SC
  //here's it's the same machine for SC and Processing
  host = "127.0.0.1";   
  oscP5event = "oscEvent";  
  oscP5 = new OscP5(this, host, sendToPort, receiveAtPort, oscP5event);
}

void oscEvent(OscIn theOscIn) {
  println("recieved");
} 

