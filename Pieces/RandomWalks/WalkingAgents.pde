int numAgents = 30;
int groups = 2;
int iterations = 20;
ArrayList<Agent> agents = new ArrayList<>();
float[] hues = new float[numAgents/groups];
ArrayList<PShape> shapes = new ArrayList<>();
int numFinished = 0;
int hueRot = 0;
float w(float in) {
  return in * width ;
}

float h(float in) {
  return 1.0*height * in;
}

void reset(){
  agents.clear();
  shapes.clear();
  
  numFinished = 0;
  for (int i=0; i<numAgents; i++) {

    PVector p = new PVector(
      random(w(0.48), w(0.52)),
      random(h(0.48), h(0.52))
      );

    PVector v = new PVector(
      random(-1, 1),
      random(-1, 1)
      );

    agents.add(new Agent(p, v, 15));
  }
  for (int i=0; i<numAgents/groups; i++) {
    hues[i] = random(360);
  }

  background(0, 0, 5);
  
}

void setup() {
  size(3000, 3000);
  colorMode(HSB, 360, 100, 100, 100);

  reset();
  blendMode(BLEND);
}


PShape getAgentBoundaries() {

  ArrayList<Agent> agentPool = new ArrayList<>(agents);
  ArrayList<PVector> vertices = new ArrayList<>();
  PVector prevP = new PVector(0, 0);


  for (int i=0; i<agents.size(); i++) {
    float frac = TWO_PI*i/agents.size();

    float x = w(0.5) * sin(frac)  + w(0.5);
    float y = w(0.5) * cos(frac)  + w(0.5);


    PVector root = new PVector(x, y);
    PVector p = new PVector(width, height);
    
    float dist = width;
    Agent ag = null;
  
    // find closest point
    for (Agent a : agentPool) {
      PVector delta = PVector.sub(root, a.p);
      float d = delta.mag() ;
      if ( d < dist ) {
        p = a.p;
        dist = d;
        ag = a;
      }
    }
    
    //add if not the last added
    if (p != prevP) {
      vertices.add(p);
      prevP = p;
    }
  }


  //convert from arraylist to pshape
  PShape outer = createShape();
  outer.beginShape();
  for (PVector p : vertices) {
    outer.vertex(p.x, p.y);
  }

  outer.endShape(CLOSE);
  return outer;
}


void draw() {
  //background(0);
  //noFill();
  //noStroke();
  stroke(hues[frameCount/100 % numAgents/groups], 100, 100, 4);
  numFinished = 0;
  for (Agent a : agents) {
    a.update();
    //ellipse(a.p.x, a.p.y, 2, 2);
    if (!a.isActive) {
      numFinished++;
    }
  }


  int h = numAgents/groups;
  hueRot++;
  for (int i=0; i<h; i++) {
    int ih = (i+hueRot) % h;
    stroke(hues[ih], 100, 100, 0.5);
    //line(agents.get(i).p.x, agents.get(i).p.y, agents.get(i+h).p.x, agents.get(i+h).p.y);
  }
  
  if (numFinished <= 3){
    stroke(hues[frameCount/100 % numAgents/groups], 100, 100, 4);
    PShape bounds = chaikin_close(getAgentBoundaries(), 0.25, 3);
    //shape(bounds);
    shapes.add(bounds);
  } else {
    noStroke();
    for (int i=shapes.size()-1;i>=0;i--){
      color c = color(hues[i % numAgents/groups], (1.0*i/shapes.size())*100, 100, 2);
      PShape s = shapes.get(i);
      s.setFill(i % 2 == 0 ? true : false);
      //s.setFill(true);
      s.setFill(c);
      shape(s);
    }
    mouseClicked();
    reset();
    //noLoop();
  }

}

void mouseClicked(){
  save("Walkers_"+str(year()) + str(month())+str(day())+str(hour())+str(minute())+str(second())+"_output.png");
}
