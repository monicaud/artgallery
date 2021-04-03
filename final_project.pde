
import java.util.*;

ArrayList<Point>    points     = new ArrayList<Point>();
ArrayList<Edge>     edges      = new ArrayList<Edge>();
ArrayList<Triangle> triangles  = new ArrayList<Triangle>();
Polygon             poly       = new Polygon();

boolean saveImage = false;
boolean animating = false;
int completeSteps = 0;

//Animation variables
int alarm = 30; //The duration of each step in the animation (in frames)
int tMax = 1; // Maximum triangles to display
int pMax = 0; //Maximum number of colored points to show
int cMax = 0; //Maximum number of color counts to show
int rCount, gCount, bCount = 0;
int step = 1;
int optimal = -1;
void setup(){
  size(800,800,P3D);
  frameRate(30);
}

void draw(){
  background(255);
  
  translate( 0, height, 0);
  scale( 1, -1, 1 );
  
  strokeWeight(3);
  
  
  fill(0);
  noStroke();

  for( Point p : points ){
    /*
    if(p.col == -1) fill(0);
    else if(p.col == 0) fill(255, 0,0);
    else if(p.col == 1) fill(0,255,0);
    else if(p.col == 2) fill(0,0,255);
    */
    p.draw();
  }
  fill(0);
  noFill();
  stroke(100);
  for( Edge e : edges ){
    e.draw();
  }
  
  stroke( 100, 100, 100 );
  if( poly.ccw() ) stroke( 100, 200, 100 );
  if( poly.cw()  ) stroke( 200, 100, 100 ); 
  poly.draw();
  
  //For testing diagonals
  /*
  fill(0);
  stroke(0);
  strokeWeight(4);
  stroke(100,100,200);
  for( Edge e : poly.getDiagonals() ){
        e.draw();
  }
  */
  stroke(0);
  
  if(animating){
    textSize(30);
    if(step == 1)
      textRHC( "Step 1: triangulation", 300, height-30 );
    else if(step == 2)
      textRHC( "Step 2: color the vertices", 300, height-30 );
    else if(step == 3)
      textRHC( "Step 3: find the most\noptimal color", 300, height-30 );
    else if(step == 4){
      textRHC( "Result", 300, height-30 );
      if(optimal == 0){
         fill(255,0,0);
         textRHC( "PLACE GUARD(S) AT RED", 300, height-70 );
         fill(0);
       }
     else if(optimal == 1){
         fill(0,255,0);
         textRHC( "PLACE GUARD(S) AT GREEN", 300, height-70 );
         fill(0);
       }
     else if(optimal == 2){
         fill(0,0,255);
         textRHC( "PLACE GUARD(S) AT BLUE", 300, height-70 );
         fill(0);
       }
    }
    
  }
  
  textSize(18);
  
  textRHC( "Controls", 10, height-30 );
  textRHC( "c: Clear Polygon", 10, height-80 );
  textRHC( "s: Save Image", 10, height-100 );
  if(!poly.isSimple()){
    fill(200);
  }
  textRHC( "a: Begin Art Gallery Animation", 10, height-120 );
  fill(0);

  textRHC( "Clockwise: " + (poly.cw()?"True":"False"), 550, 80 );
  textRHC( "Counterclockwise: " + (poly.ccw()?"True":"False"), 550, 60 );
  textRHC( "Closed Boundary: " + (poly.isClosed()?"True":"False"), 550, 40 );
  textRHC( "Simple Boundary: " + (poly.isSimple()?"True":"False"), 550, 20 );

  for( int i = 0; i < points.size(); i++ ){
    textRHC( i+1, points.get(i).p.x+5, points.get(i).p.y+15 );
  }
  
  if( saveImage ) saveFrame( ); 
  saveImage = false;
  
  if(animating){
    noFill();
    stroke(100,100,200);
    for(int i = 0; i < tMax; i++){
     noFill();
     stroke(100,100,200);
     Triangle t = triangles.get(i);
     t.draw(); 
     
     noStroke();
    }
    
    for(int i = 0; i<pMax; i++){
      Point p = points.get(i);
      if(p.col == -1) fill(0);
      else if(p.col == 0) fill(255, 0,0);
      else if(p.col == 1) fill(0,255,0);
      else if(p.col == 2) fill(0,0,255);
    
      p.draw();
    }
    fill(0);
    
    for(int i = 0; i<cMax; i++){
      if (i == 0){
        rCount = redPointCount();
        fill(255,0,0);
        textRHC( "Red: " + Integer.toString(rCount), 10, height-240 );
      }
      else if (i == 1){
        gCount = greenPointCount();
        fill(0,255,0);
        textRHC( "Green: " + Integer.toString(gCount), 10, height-260 );
      }
      else if (i == 2){
        bCount = bluePointCount();
        fill(0,0,255);
        textRHC( "Blue: " + Integer.toString(bCount), 10, height-280 );
      }
    }
    fill(0);
    
    
    if(alarm > 0){
      alarm--;
    }
    else{
     if(step == 1){
       if(tMax >= triangles.size()){
         step++;
       }
       else
         tMax++;
     }
     else if(step == 2){
       if(pMax >= points.size()){
         step++;
       }
       else
         pMax++;
     }
     else if(step == 3){
       cMax++;
       if(cMax >= 3){
         step++;
       }
     }
     else if(step == 4){
       if(gCount <= rCount && gCount <= bCount){
         optimal = 1;
       }
       else if(bCount <= rCount && bCount <= gCount){
         optimal = 2;
       }
       else
         optimal = 0;
     }
     alarm = 30;
    }
  }
  
  
}

void keyPressed(){
  if( key == 's' ) saveImage = true;
  if( key == 'c' ) reset(); 
  if( key == 'a' && !animating && poly.isSimple()){
    poly.generateTriangles();
    poly.getDual();
    animating = true;
  }
}

void textRHC( int s, float x, float y ){
  textRHC( Integer.toString(s), x, y );
}

void textRHC( String s, float x, float y ){
  pushMatrix();
  translate(x,y);
  scale(1,-1,1);
  text( s, 0, 0 );
  popMatrix();
}

void reset(){
  points.clear(); 
  triangles.clear(); 
  poly = new Polygon(); 
  animating = false;
  alarm = 30;
  tMax = 1;
  pMax = 0;
  cMax = 0;
  optimal = -1;
  step = 1;
}

int redPointCount(){
  int i = 0;
  for(Point p : points){
    if (p.col == 0)
      i++;
  }
  return i;
}

int greenPointCount(){
  int i = 0;
  for(Point p : points){
    if (p.col == 1)
      i++;
  }
  return i;
}

int bluePointCount(){
  int i = 0;
  for(Point p : points){
    if (p.col == 2)
      i++;
  }
  return i;
}

Point sel = null;

void mousePressed(){
  int mouseXRHC = mouseX;
  int mouseYRHC = height-mouseY;
  
  if(!animating){
    float dT = 6;
    for( Point p : points ){
      float d = dist( p.p.x, p.p.y, mouseXRHC, mouseYRHC );
      if( d < dT ){
        dT = d;
        sel = p;
      }
    }
  
  
    if( sel == null){
      sel = new Point(mouseXRHC,mouseYRHC);
      points.add( sel );
      poly.addPoint( sel );
    }
  }
}

void mouseDragged(){
  int mouseXRHC = mouseX;
  int mouseYRHC = height-mouseY;
  
  if(!animating){
    if( sel != null ){
      sel.p.x = mouseXRHC;   
      sel.p.y = mouseYRHC;  
    }
  }
}

void mouseReleased(){
  sel = null;
}
