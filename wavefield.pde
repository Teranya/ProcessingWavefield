//3D Terrain Generation with Perlin Noise 
//https://www.youtube.com/watch?v=IKB1hWWedMk

import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

import ddf.minim.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
//BeatListener bl;

int cols;
int rows;
int scl = 20; //scale 
int w=2200;
int h =1220;

float flying = 0;

float [][] terrain; //2D arrays  
  
void setup(){
 
  size(1220,800, P3D); //3d environment

  cols= w/scl;
  rows = h/scl;
  terrain = new float [cols][rows];
  // always start Minim before you do anything with it
  minim = new Minim(this);
  frameRate( 30 );
  smooth();
  song = minim.loadFile("Moon Boots - First Landing.mp3", 2048);

  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  // set the sensitivity to 300 milliseconds
  // After a beat has been detected, the algorithm will wait for 300 milliseconds 
  // before allowing another beat to be reported. You can use this to dampen the 
  // algorithm if it is giving too many false-positives. The default value is 10, 
  // which is essentially no damping. If you try to set the sensitivity to a negative value, 
  // an error will be reported and it will be set to 10 instead. 
  // note that what sensitivity you choose will depend a lot on what kind of audio 
  // you are analyzing. in this example, we use the same BeatDetect object for 
  // detecting kick, snare, and hat, but that this sensitivity is not especially great
  // for detecting snare reliably (though it's also possible that the range of frequencies
  // used by the isSnare method are not appropriate for the song).
  beat.setSensitivity(300);  
 // bl = new BeatListener(beat, song);  

  song.play();
}

void draw(){

   
  flying -= 0.08;
  
  float yoff=flying;
  for(int y= 0 ;y< rows; y++){ 
    float xoff=0;
   for( int x= 0; x< cols; x++){
     terrain[x][y] = map(noise(xoff,yoff),0,1,-song.mix.level()*400,song.mix.level()*400); //gives a noise value for every x and y also maps the noise 
                                                  //values that goes between 0 & 1 to some value between -100 & 100 
    xoff += 0.1; 
   }
   yoff += 0.08;
 }
  
  
   background (0);
   stroke(255,0,0,50);
 //  noFill();
 fill (0,0,255,50);
   translate (width/5,height/2 );//everything is drawn relative to the centre of the winod this way
   rotateX(PI/3); //rotates it all by 60 deg backwards
   
   translate (-width/2,-height/2);
   for(int y= 0 ;y< rows-1; y++){ //outer loop of triangles has to be y ( take y and do all the x's)
    beginShape(TRIANGLE_STRIP);
   for( int x= 0; x< cols; x++){ //each triangle row will be 1 strip
       vertex(x*scl, y*scl,terrain[x][y] ); //random(-10,10) randomizes the z values, give it all heights
       vertex(x*scl, (y+1)*scl,terrain[x][y+1]); //creates the third
     //  rect(x*scl,y*scl,scl,scl);
    
     }
      endShape();
   }
   
}
void stop()
{
  // always close Minim audio classes when you are done with them
  song.close();
  minim.stop();

  super.stop();
}