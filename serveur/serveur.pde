import processing.net.*;

import processing.serial.*; 
 
Serial port;        // Create object from Serial class
 
String HTTP_HEADER = "HTTP/1.0 200 OK\nContent-Type: text/html\n\n";
Server s;
Client c;

String[] lines;
boolean firstLaunch=false;
String html="";

void setup() {
  
   frameRate(10);
   
  s = new Server(this, 5400);

  lines = loadStrings("index.html");
  for (int i = 0; i < lines.length; i++) {
    html +=lines[i]+"\n";
  }
  //println(html);
  // Open the port that the board is connected to and use the same speed (9600 bps)
  port =new Serial(this, Serial.list()[0], 9600);
}

void draw() {
  c = s.available();
  if (c != null) {
    String msgClient=c.readString();
    println(msgClient);

    if (msgClient.indexOf("led=1") != -1) {
      println ("The led is on");
      port.write('H');
      s.write(HTTP_HEADER);
      s.write("The Led is ON");
      // s.write("\n");
      c.stop();
    }

    if (msgClient.indexOf("led=0") != -1) {
      println ("The led is off");
      port.write('L');
      s.write(HTTP_HEADER);
      s.write("The Led is OFF");
      //s.write("\n");
      c.stop();
    }

    if (c!=null) { // at start and in case of F5 refresh
      s.write(HTTP_HEADER);
      s.write(html);
      c.stop();
    }
  }
}
