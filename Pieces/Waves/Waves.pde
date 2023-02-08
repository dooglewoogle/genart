float grid[][];
int left_x, right_x, top_y, bottom_y, resolution;
color seaPalette[] = new color[]{#00337C, #1C315E, #13005A, #227C70, #1C82AD, #88A47C, #03C988};

float noiseAmp = 1.0;
float noiseFreq = 0.1;

float hueVar = 1;
float satVar = 2;


float w(float in) {
  return width * in;
}

float h(float in) {
  return height * in;
}

double easeInCubic(float in){
  return in * in * in;
}

double easeOutCubic(float in){
  double a = 1.0 - easeInCubic(in);
  return 1.0 - Math.pow(1.0 - in, 3.0);
}

void gridLine(float x1, float y1, float x2, float y2){
  float tmp;
  if (x1 > x2 ) {tmp = x1; x1=x2; x2=tmp; tmp = y1;y1=y2;y2=tmp;}
  float dx = x2 - x1;
  float dy = y2 - y1;
  float step = 1;
  
  if (x2 < x1 ){
    step = -step;
  }
  float sx = x1;
  float sy = y1;
  
  for (float x = x1+step; x <=x2; x+=step){
    float y = y1 + step * dy * (x-x1) / dx;
    strokeWeight( 1 + map(noise(sx, sy), 0, 1, -0.5, 0.5));
    line(sx, sy, x+map(noise(x, y), 0, 1, -1, 1), y+map(noise(x, y), 0, 1, -1, 1));
    sx = x;
    sy = y;
  }
  
}

void drawGrid(){
  float spacing = 5;
  strokeWeight(1);
  for (int i=-width;i <height+width;i+=spacing){
    stroke(0,0,0, random(0.5, 3));
    gridLine(i, 0, i+height, height);
  }
  for (int i=height+width; i >= -width; i-=spacing){
    stroke(0,0,0, random(0.5, 3));
    gridLine(i, 0, i-height, height);
  }
}

void drawWaves(){
  strokeWeight(1);
  for (int i=0;i<width;i++){
    float a = sin(1.0*i/w(0.052));
    float b = cos(1.0*i/w(.213));
    stroke(map(a*b, -1, 1, 25.5, 255), 5);
    line(i,0, i, height);
  }
}


void setup() {
  size(2000, 2000);
  frameRate(1);
  strokeWeight(30);
  colorMode(HSB, 360, 255, 255, 100);
  
  left_x = int(width * -1.5);
  right_x = int(width * 1.5);
  top_y = int(height * -0.5);
  bottom_y = int(height * 1.5);

  resolution = int(width * 0.01 );

  int num_columns = (right_x - left_x) / resolution, num_rows = (bottom_y - top_y) / resolution;

  grid = new float[num_columns][num_rows];

  for (int y=0;y<num_columns;y++) {     
    for (int x=0;x<num_rows;x++) {         
      //grid[y][x] = (x / float(num_rows)) * PI;
      float rawAngle = noise(x*noiseFreq, y*noiseFreq) * noiseAmp;
      float angle = map(rawAngle, 0, 1, 0, HALF_PI);
      angle -= radians(35);

      grid[y][x] = angle;

    } 
  }
  


}

void drawCurve(int sx, int sy, color baseColor, float baseStrokeWeight){
  int steps = 60;
  float stepLength = w(0.0625);
  int x = sx;
  int y = sy;
  float weight = 0.0;


  
  beginShape();
  curveVertex(x, y);
  for (int i=0;i<steps;i++){
    curveVertex(x, y);
    
    int d = (int) steps/4;
    if ( i < d ){
      weight = map2( (float)i, 0.0, d, 0, baseStrokeWeight, CUBIC, EASE_OUT);
    } else if ( i > d*3 ){
      weight = map2( (float)i, d*3, steps, baseStrokeWeight,0, CUBIC, EASE_IN);
    } else {
      weight = baseStrokeWeight;
    }
    weight = max(weight, 0);
    strokeWeight(weight);
    
    int xOff = x - left_x;
    int yOff = y - top_y;
    int columnIndex = int(xOff / resolution);
    int rowIndex = int(yOff / resolution);
    
    //TODO: bounds check
    if (columnIndex >= grid.length || rowIndex >= grid[columnIndex].length ||
        columnIndex < 0 || rowIndex < 0){
      break;
    }
    
    float angle = grid[columnIndex][rowIndex];
    
    float xStep = stepLength * cos(angle);
    float yStep = stepLength * sin(angle);
    
    float hue = hue(baseColor) + randomGaussian()*hueVar;
    float sat = 30+saturation(baseColor) + randomGaussian() * satVar;
    float b = 30+ brightness(baseColor);
    
    stroke(hue, sat, b, 20);

    x = x + floor(xStep);
    y = y + floor(yStep);
    
  }
  
  curveVertex(x, y);
  endShape();
}

void draw(){
  noFill();
  smooth();
  background(#082B40);
  //background(0);
  
  
  for (int i=0;i<2000;i++){
    color baseColor = seaPalette[ min(floor(abs(randomGaussian()*5)), 6) ];
    float strokeWeight = w(0.0125) + randomGaussian() * w(0.0125);
    drawCurve(floor(random(-width, 0)), floor(random(-height*.4, height*1.2)), baseColor, strokeWeight);
  }
  
  drawGrid();
  drawWaves();
  

}

void mousePressed(){
  save("FlowPaint_" + year() + month() + day() + hour()+minute()+second() + ".tif");
}
