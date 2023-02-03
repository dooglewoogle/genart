PShader glass;
PImage img; 
int scale = 2000;

float diamondHueVar = 5.;

float w(float in){
  return width * in;
}

float h(float in){
  return height * in;
}

void settings(){
  size(scale,scale, P2D);
}

void setup() {


  frameRate(1);
  glass = loadShader("texturedGlass.glsl"); 
  img = loadImage("tvn7dtcd90891.png");
  colorMode(HSB, 360, 100, 100, 100);
  stroke(0, 0, 0);
  
}

void blurEllipse(float x, float y, float size){
  for (int i=0;i<50;i++){
    ellipse(w(x), h(y), (w(size)+i*5), (h(size)+i*5));
  }
}

float clamp(float val, float min, float max){return max(min, min(val, max));}

PShape diamond(PVector center, float size){
  PShape s = createShape();
  s.beginShape();
  
  s.vertex(w(center.x), h(center.y-size));
  s.vertex(w(center.x+size), h(center.y));
  s.vertex(w(center.x), h(center.y+size));
  s.vertex(w(center.x-size), h(center.y));
  s.endShape(CLOSE);
  return s;
}

void draw() {
  
  glass.set("depth", w(.00004));
  glass.set("scale", w(.14));
  background(0);

  noStroke();
 
 //random bg 
 //lower
  for (int i=0;i<30;i++){
    fill(120+randomGaussian()*180, 25, 250+randomGaussian()*10, 50);
    ellipse(
      random(w(-.5),w(1.5)),
      random(w(.4),w(1.3)),
      randomGaussian() * w(0.7),
      randomGaussian() * w(0.7)
    );
  }
  //upper
  for (int i=0;i<30;i++){
    fill(210+randomGaussian()*60, 25, 250+randomGaussian()*10, 50);
    ellipse(
      random(w(-.5),w(1.5)),
      random(w(-.5),w(0.4)),
      randomGaussian() * w(0.9),
      randomGaussian() * w(0.9)
    );
  }
  
  
  float startHue = random(360);
  strokeWeight(w(.03));
  //cyan spheres
  fill(startHue+randomGaussian()*diamondHueVar, 62, 99, 80);
  stroke(60+startHue+randomGaussian()*diamondHueVar, 62, 99, 80);
  
  shape(diamond(new PVector(0.5, 0.3), 0.18));
  startHue = (startHue + 90) % 360;

  fill(startHue+randomGaussian()*diamondHueVar, 62, 99, 80);
  stroke(20+startHue+randomGaussian()*diamondHueVar, 62, 99, 80);
  shape(diamond(new PVector(0.7, 0.5), 0.18));
  startHue = (startHue + 90) % 360;

  fill(startHue+randomGaussian()*diamondHueVar, 62, 99, 80);
  stroke(20+startHue+randomGaussian()*diamondHueVar, 62, 99, 80);
  shape(diamond(new PVector(0.5, 0.7), 0.18));
  startHue = (startHue + 90) % 360;
  
  fill(startHue+randomGaussian()*diamondHueVar, 62, 99, 80);
  stroke(20+startHue+randomGaussian()*diamondHueVar, 62, 99, 80);
  shape(diamond(new PVector(0.3, 0.5), 0.18));



  // draw lines
  
  strokeWeight(w(.017));
  stroke(222, 12, 30, 100);
  for (int i=-width;i<width*2;i+=w(0.20)){
    line(i, 0, i+width, height);
  }
  
  for (int i=width*2;i>-width;i-=w(0.20)){
    line(i, 0, i-width, height);
  }
  
  filter(glass);  
  

}

void mousePressed(){
  save("StainedGlass_" + year() + month() + day() + hour()+minute()+second() + ".png");
}
