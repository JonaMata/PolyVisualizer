import ddf.minim.*;
import ddf.minim.analysis.*;

AudioPlayer ap;
Minim minim;
BeatDetect beat;

int cols, rows;
float[][] points;
float colour;

int scale = 50;
float moderator = 1000;
float smoothness = 5;
float flying = 0;

void setup() {

  //size(900, 600, P3D);
  //translate(width/2, height/2, 0);
  fullScreen(P3D);
  colorMode(HSB);
  smooth();
  minim = new Minim(this);
  ap = minim.loadFile("song.mp3");
  ap.loop();
  beat = new BeatDetect();
  
  cols = width/scale;
  rows = height/scale;
  
  points = new float[cols][rows];
}

void draw() {
  float level = ap.mix.level();
  float leftLevel = ap.left.level();
  float rightLevel = ap.right.level();
  
  //flying += 0.1;
  float yoff = flying;
  float xoff = flying;
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      points[x][y] = ap.mix.get(x)*moderator*noise(xoff, yoff);
      xoff += 0.2;
    }
    yoff += 0.2;
  }
  
  beat.detect(ap.mix);
  if (beat.isOnset()) {
    colour += 50;
    if (colour > 255) {
      colour -= 255;
    }
  }
  
  
  background(0);
  
  stroke(colour, 100, 100);
  strokeWeight(2);
  noFill();
  
  translate(width/2, height/2+50);
  rotateX(PI/3);
  
  translate(-width/2, -height/2);
  
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      vertex(x*scale, y*scale, points[x][y]);
      vertex(x*scale, (y+1)*scale, points[x][y+1]);
    }
    endShape();
  }
  
  
}
