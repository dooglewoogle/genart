class Agent{
  public PVector p;
  private PVector v;
  private PVector a;
  private float maxAngle;
  private float maxForce = width*.0007;
  private boolean isActive;
  private float margin = 0.05;
  
  Agent(PVector p, PVector v, float maxAngle){
    this.p = p;
    this.v = v;
    this.maxAngle = radians(maxAngle);
    this.a = new PVector(0, 0);
    isActive = true;
  }
  
  public void update(){
    
    //if (!isActive){return;}
    
    a = new PVector(0, 0);
    float thisAngle = random(-maxAngle, maxAngle);
    PVector heading = v; ////FFFFFFFFFUUUUUUUUUU
    heading.normalize();
    heading.rotate(thisAngle);
    addForce(heading);
    
    // intergrate v
    v.add(a);
    if (v.mag() > 2.0){
    }
    
    // intergrate p
    p.add(v);
    
    if (p.x <= width*margin || p.x >= width* (1-margin) || p.y <=height*margin || p.y >= height* (1-margin) ){
      isActive = false;
      maxForce = width*.0002;
    } 
  }
  
  public void draw(){
    //ellipse(p.x, p.y, 1, 2);
    point(p.x, p.y);
  }
  
  private void addForce(PVector f){
    a.add(f.mult(maxForce));
  }
  
  
}
