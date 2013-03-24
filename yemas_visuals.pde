// based on the work SpaceJunk of Ira Greenberg

//import processing.opengl.*;
import oscP5.*;
import netP5.*;

import processing.video.*;
import jp.nyatla.nyar4psg.*;

Capture cam;
MultiMarker nya;

OscP5 oscP5;
NetAddress myRemoteLocation;

// Used for oveall rotation
float ang;

// Array for all cubes
Cube[]cubes = new Cube[500];

//OSC incoming data
float dato1;
float dato2;
float dato3;
float dato4;

void setup() {
  size(1280, 720, P3D);
  oscP5 = new OscP5(this, 5000);   
  background(0); 
  noStroke();

  // Instantiate cubes, passing in random vals for size and postion
  for (int i = 0; i< cubes.length; i++) {
    cubes[i] = new Cube(int(random(-10, 10)), int(random(-10, 10)), 
    int(random(-10, 10)), int(random(-140, 140)), int(random(-140, 140)), 
    int(random(-140, 140)));
  }

  // requeriments to AR extracted from MultiMarker.pde example
  cam=new Capture(this, 1280, 720);
  nya=new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker("patt.hiro", 80);//id=0
  nya.addARMarker("patt.kanji", 80);//id=1
}

void draw() {
  if (cam.available() !=true) {
    return;
  }
  cam.read();
  nya.detect(cam);
  background(0); 
    nya.drawBackground(cam);
  fill(255);

  // Set up some different colored lights
  pointLight(dato3, 255, dato3, 65, 60, 100); 
  pointLight(255, 0, 10, -65, -60, -150);

  // Raise overall light in scene 

  ambientLight(10, 30, 50); 

  // Center geometry in display windwow.
  // you can change 3rd argument ('0')
  // to move block group closer(+)/further(-)
  //translate(width/2, height/2, -200 + dato2 * 1.65);

  // Draw cubes
  //  for (int i = 0; i < cubes.length; i++) {
  //    cubes[i].drawCube();
  //  }

  for (int i=0;i<2;i++) {
    if ((!nya.isExistMarker(i))) {
      continue;
    }
    println("entro");
    nya.beginTransform(i);
    //fill(0, 100*(i%2), 100*((i+1)%2));
    translate(0, 0, -100+ dato2 * 1.65);
    rotateY(radians(ang));
    rotateX(radians(ang));

    for (int j = 0; j < cubes.length; j++) {
      cubes[j].drawCube();
    }
    nya.endTransform();
  }

  // Scale cubes
  for (int i = 0; i < cubes.length; i++) {
    cubes[i].scaleCube((int)pow(1.065, dato1/1.1));
  }

  // Used in rotate function calls above
  ang += dato1/30;
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  if (theOscMessage.checkAddrPattern("/datos")) {
    dato1 =(float)(theOscMessage.get(0).floatValue());
    dato2 =(float)(theOscMessage.get(1).floatValue());
    dato3 =(float)(theOscMessage.get(2).floatValue());
    dato4 =(float)(theOscMessage.get(3).floatValue());
    println(dato1+" "+dato2+" "+dato3+" "+dato4+" ");
  }
}

