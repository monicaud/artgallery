class Triangle {
  
   Point p0,p1,p2;
   ArrayList<Point> pointArray = new ArrayList<Point>();
     
   Triangle(Point _p0, Point _p1, Point _p2 ){
    p0 = _p0; p1 = _p1; p2 = _p2;
     pointArray.add(p0);
     pointArray.add(p1);
     pointArray.add(p2);
   }
   
   void draw(){
    triangle( p0.p.x,p0.p.y, 
               p1.p.x, p1.p.y,
               p2.p.x, p2.p.y );   
   }
   
   boolean ccw(){
     PVector v1 = PVector.sub( p1.p,p0.p );
     PVector v2 = PVector.sub( p2.p,p0.p );
     float z = v1.cross(v2).z;
     return z > 0;
   }
   
   boolean cw(){
     PVector v1 = PVector.sub( p1.p,p0.p );
     PVector v2 = PVector.sub( p2.p,p0.p );
     float z = v1.cross(v2).z;
     return z < 0;
   }
   
   float area(){
     PVector v1 = PVector.sub( p1.p,p0.p );
     PVector v2 = PVector.sub( p2.p,p0.p );
     float z = v1.cross(v2).z;
     return (z/2);     
   }
   
   boolean adjacentTo(Triangle t){
     return (t.pointArray.contains(p0) && t.pointArray.contains(p1)) || (t.pointArray.contains(p0) && t.pointArray.contains(p2)) || (t.pointArray.contains(p1) && t.pointArray.contains(p2)); 
   }
   
   void setColors(){
     if(p0.col == -1){
      if(p1.col != 0 && p2.col != 0){
        p0.col = 0;
        }
      else if(p1.col != 1 && p2.col != 1){
        p0.col = 1;
        }
      else if(p1.col != 2 && p2.col != 2){
        p0.col = 2;
        }
      }
           
    if(p1.col == -1){
      if(p0.col != 0 && p2.col != 0){
        p1.col = 0;
        }
      else if(p0.col != 1 && p2.col != 1){
        p1.col = 1;
      }
      else if(p0.col != 2 && p2.col != 2){
        p1.col = 2;
      }
    }
    if(p2.col == -1){
      if(p1.col != 0 && p0.col != 0){
        p2.col = 0;
      }
      else if(p1.col != 1 && p0.col != 1){
        p2.col = 1;
      }
      else if(p1.col != 2 && p0.col != 2){
        p2.col = 2;
      }
    }
   }
   
}
