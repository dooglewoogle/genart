import algorithms.noise.*;
OpenSimplexNoise Gen;

float startSize = 0.5;
float radius = startSize;
float noiseFreq = 1.0;
float noiseAmp = 0.1;

int m;
float rad = 1.0;
float nperiod = 20.0;

int numHues = 15;
float[] hues = new float[numHues];

int maxStars = 3;
int thisStar =0;

float w(float in) {
  return in * width ;
}

float h(float in) {
  return 1.0*height * in;
}

void setup() {
  size(2000, 2000);
  Gen = new OpenSimplexNoise();
  colorMode(HSB, 360, 100, 100, 100);
  m = 3 * width;
  reset();
  
  smooth();
  blendMode(BLEND);
  background(0);
  noFill();
}

void reset() {

  int startHue = floor(random(360));
  nperiod = random(2, 6);

  for (int i=0; i<numHues; i++) {
    hues[i] = startHue + randomGaussian() * 20;
  }
  //background(0);
}




void draw() {

  int hueI = frameCount/100 % numHues;
  float lerpAmt = 1.0*frameCount / 100 % 1;
  float hue = lerp(1.0*hues[hueI], 1.0*hues[min(hueI+1, numHues-1)], lerpAmt);

  float t = 1.0*(frameCount-1)/101;
  radius = (1.0*(frameCount)/(0.4*width) % 1);

  float saturation = lerp( 20, 100, pow(radius, 0.5));
  stroke(hue, saturation, 100, 4);

  if (radius < 0.001){
    save("GrowingNoise_"+str(year()) + str(month())+str(day())+str(hour())+str(minute())+str(second())+"_output.png");
    reset();
  }

  noiseAmp = map(radius, 0, 1, 0, 0.3);
  noiseFreq = map(radius, 0, 1, 1, 4);


  

    for (int i=0; i<m; i++) {

      float normIndex = 1.0*i/m;

      float n1 = Gen.noise(
        noiseFreq*cos(TWO_PI*normIndex*nperiod),
        noiseAmp*sin(TWO_PI*normIndex*nperiod),
        t
        );
      n1 = map(n1, 0, 1, -noiseAmp, noiseAmp);

      float x = radius*cos(TWO_PI*normIndex)+n1;
      float y = radius*sin(TWO_PI*normIndex)+n1;

      point((x*width/2)+width/2, (y*height/2)+height/2);
    }
  }
