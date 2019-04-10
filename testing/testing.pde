import controlP5.*;
ControlP5 cp5; 
Slider Cone; 
Button saveB;

//Arduino
import processing.serial.*;
Serial myPort; 
String val; 
float vol;  //blue
float vol2; //white
byte[] inBuffer = new byte[255];
int id =0;

import processing.sound.*;
import ddf.minim.*;

//Sound
AudioIn input; 
Amplitude analyzer;

float inVolLeft;
float inVolRight;

ArrayList<Object> boom = new ArrayList<Object>();
ArrayList<ObjectR> boomR = new ArrayList<ObjectR>();
ArrayList<Object> temp = new ArrayList<Object>();
ArrayList<ObjectM> merge = new ArrayList<ObjectM>(); 
ArrayList<Particle> explosion = new ArrayList<Particle>();

int[] yRange = new int[6]; 

PrintWriter output;

void setup() {
  size(1900, 1000);
  //size(screen.width, screen.height); 
  //surface.setResizable(true);
  // cp5 = new ControlP5(this);
  //  cp5.addSlider("cone")
  //   .setRange(1,200)
  //   .setValue(1)
  //   .setPosition(100,200)
  //   .setSize(100,10)
  //   ;
  cp5 = new ControlP5(this);
  saveB = createButton("save", "Save Image", 100, 100);


  ////audio via computer mic////
  input = new AudioIn(this, 0); 
  input.start();
  analyzer = new Amplitude(this);   
  analyzer.input(input);
  
  
  
  ////yRange initialize////
  yRange[0] = -20;
  yRange[1] = -15;
  yRange[2] = -10;
  yRange[3] = 10;
  yRange[4] = 15;
  yRange[5] = 20;
  
  ////arduino setup ////
  myPort = new Serial(this, Serial.list()[0], 9600); 
 
}

void draw() {
  
  ////bg////
  background(0);
  
  ////arduino connection code////
  
  if(myPort.available() > 0 ){
    println("  "); 
    
    myPort.readBytesUntil('&', inBuffer); 
    
    if(inBuffer != null){
       String s1 = new String(inBuffer); 
       
       String[] p = splitTokens(s1, "&"); 
       if(p.length<2) return; 
       
       String[] mic1 = splitTokens(p[0], "a"); 
       if(mic1. length != 3) return; 
       
       vol  = float(mic1[1]); 
       
       print("1st sensor:");
       print(vol);
       println(" "); 
       
       String[] mic2 = splitTokens(p[0],"b"); 
       if(mic2.length != 3) return; 
       vol2 = float(mic2[1]); 
       
       print("2nd sensor:"); 
       print(vol2); 
       println("  "); 
    }       
  }
  //port available
    
  /////Room Tone ////
  // if (vol<5){
  //  vol = 5;  
  // }

  ////Draw output from left side////
  for (int i = 0; i < boom.size(); i++) {
    Object o = boom.get(i);
    o.drawMe();
    
    if (o.x > width || o.x < 0 || o.y > height || o.y < 0) {
      boom.remove(o);
    }
  }

  ////Draw output from right side////
  for (int i = 0; i < boomR.size(); i++) {
    ObjectR r = boomR.get(i);
    r.drawMe();

    if (r.x > width || r.x < 0 || r.y > height || r.y < 0) {
      boomR.remove(r);
    }
  }
  
  ////Draw merged objects////
  for(int m = 0; m<merge.size(); m++){
     merge.get(m).drawMe();  
  }
  
  ////Draw explosions////
  for (int i = 0; i < explosion.size(); i++) {
    Particle p = explosion.get(i);
    p.drawMe();
  }

  ////input for left side//// 
  if (keyPressed == false) {
  //if (keyPressed) {
    /////using comp mic
    //float vol = 100*analyzer.analyze();
    if (vol<2) {
      vol = 1;
    }
    if(vol>=200){
      vol = 200; 
    }
    Object o = new Object();
    o.x = 0;
    o.y = height/2;
       
    if(vol<6){
      o.xVel = random(1,3);
      o.yVel = random(-0.3,0.3); 
    }
    else if(vol>=6 && vol<200){
      o.xVel = random(4, 6);
      o.yVel = random(-3, 3);
    }
    else if(vol>=200){
      o.xVel = random(7,12);
      float yR = random(0,5);
      o.yVel = yRange[(int)yR];
      //o.yVel = random(-9, 9);
    }
    //with input
    o.w = vol;
    o.h = vol;
    //without input
    //o.w = 110; 
    //o.h = 110; 
    boom.add(o);
  }



  ////input for right side////
  if (keyPressed == false) {
    //if (keyPressed && keyCode == RIGHT) {
    //using comp mic
    //float vol2 = 100*analyzer.analyze();
    if(vol2<2){
       vol2 = 1;  
    }
    if(vol2>=200){
      vol2 = 200; 
    }
    ObjectR r = new ObjectR();
    r.x = width;
    r.y = height/2;
    if(vol2<6){
      r.xVel = random(-3,-1);
      r.yVel = random(-0.3,0.3); 
    }
    else if(vol2>=6 && vol2<200){
      r.xVel = random(-6, -4);
      r.yVel = random(-3, 3);
    }
    else if(vol2>=200){
      r.xVel = random(-12, -7);
      float yR2 = random(0,5);
      r.yVel = yRange[(int)yR2];
    }
    //with input
    r.w = vol2;
    r.h = vol2;
    //without input
    //r.w = 100;
    //r.h = 100;

    boomR.add(r);
  }

}

Button createButton(String key, String label, float x, float y){
  Button b = cp5.addButton(key)
  .setLabel(label)
  .setSize(75, 50)
  .setPosition(x, y);

  return b;
}

void save() {
  save("sss" + id + ".jpg");
  println("saved image");
  id ++;
}

void cone(float l){
  vol = l ;
}