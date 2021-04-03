import java.text.DecimalFormat;
class Polygon {
  
   ArrayList<Point> p     = new ArrayList<Point>();
   ArrayList<Edge>  bdry = new ArrayList<Edge>();
     
   Polygon( ){  }
   
   
   boolean isClosed(){ return p.size()>=3; }
   
   
   boolean isSimple(){
     //polygon is simple if non adjacent edges do not intercept
     ArrayList<Edge> bdry = getBoundary();
     for (int i = 0; i < bdry.size(); i++){
       for (int j = 0; j < bdry.size(); j++){
           if(bdry.get(i).p0 == bdry.get(j).p0 || bdry.get(i).p1 == bdry.get(j).p0 || bdry.get(i).p0 == bdry.get(j).p1 || bdry.get(i).p1 == bdry.get(j).p1){
             //adjacent vertices get ignored because they are supposed to have an intersection
             continue;
           }
           if(bdry.get(i).intersectionTest(bdry.get(j))){
             return false;
           }
       }
     }
     
     //polygon must be a triangle at least!
     if(isClosed()){
       return true;
     }
     
     return false;
   }
   
   boolean ccw(){
     if( !isClosed() ) return false;
     if( !isSimple() ) return false;
     
     PVector pv0 = p.get(0).p;
     PVector pv1 = p.get(1).p;
     PVector pv2 = p.get(p.size()-1).p;
     
     float zA = (pv0.cross(pv1)).z; //Z component of the cross product of p0 and p1
     float zB = (pv1.cross(pv2)).z; //Z component of the cross product of p1 and p2
     float zC = (pv2.cross(pv0)).z; //Z component of the cross product of p2 and p0
     return (zA+zB+zC > 0);
   }
   
   
   boolean cw(){
     if( !isClosed() ) return false;
     if( !isSimple() ) return false;
     
     PVector pv0 = p.get(0).p;
     PVector pv1 = p.get(1).p;
     PVector pv2 = p.get(p.size()-1).p;
     
     float zA = (pv0.cross(pv1)).z; //Z component of the cross product of p0 and p1
     float zB = (pv1.cross(pv2)).z; //Z component of the cross product of p1 and p2
     float zC = (pv2.cross(pv0)).z; //Z component of the cross product of p2 and p0
     return (zA+zB+zC < 0);
   }

   ArrayList<Edge> getBoundary(){
     return bdry;
   }

   boolean pointInPolygon( Point p ){
     ArrayList<Edge> bdry = getBoundary();
     int num_intersections, odd_intersections, even_intersections;
     num_intersections = 0;
     odd_intersections = 0;
     even_intersections = 0;
     for(int i=0;i<20;i++)
     {
        //ArrayList<Edge> bdry_copy = bdry;
        Point p1 = new Point( PVector.fromAngle(random(0,2*PI)).mult(1000).add(p.p)); 
        Edge e = new Edge(p,p1);
        bdry.add(e);
        for(int j=0;j<bdry.size();j++){
          if(bdry.get(j).intersectionTest(e))
          num_intersections++;
        }
        if (num_intersections % 2 == 0)
          even_intersections++;
        else
          odd_intersections++; 
        bdry.remove(bdry.size()-1);
     }
     if(odd_intersections < even_intersections) //For some reason, the output of this function is the reverse of what it should be
       return true;
     else
       return false;
   }
   
   ArrayList<Edge> getPotentialDiagonals(){
     ArrayList<Edge> ret = new ArrayList<Edge>();
     int N = p.size();
     for(int i = 0; i < N; i++ ){
       int M = (i==0)?(N-1):(N);
       for(int j = i+2; j < M; j++ ){
         ret.add( new Edge( p.get(i), p.get(j) ) );
       }
     }
     return ret;
   }
   ArrayList<Edge> getDiagonals(){
      //<>//
     ArrayList<Edge> bdry = getBoundary();
     ArrayList<Edge> diag = getPotentialDiagonals();
     ArrayList<Edge> ret  = new ArrayList<Edge>();
     DecimalFormat df = new DecimalFormat("###.00");
     boolean totallyOutside = false;
     boolean outside = false;
     boolean x = false;
     boolean y = false;
     
     for(int j = 0; j < diag.size(); j++){
          x = false;
          y = false;
          totallyOutside = false;
          outside = false;
        for(int i = 0; i < bdry.size(); i++){

          //diagonals shouldnt intersect the boundary
          if(diag.get(j).intersectionTest(bdry.get(i))){

            //check that it's not just one of the endpoints
            Point intersection = diag.get(j).intersectionPoint(bdry.get(i));
            
            if(intersection != null){
              
              String pointX = df.format(intersection.p.x);
              String pointY = df.format(intersection.p.y);
              
              String endPoint0x = df.format(diag.get(j).p0.p.x);
              String endPoint0y = df.format(diag.get(j).p0.p.y);
              
              String endPoint1x = df.format(diag.get(j).p1.p.x);
              String endPoint1y = df.format(diag.get(j).p1.p.y);
              
              if( pointX.equals(endPoint0x) || pointX.equals(endPoint1x)) 
                x = true;
              else
                x = false;
              
              if(pointY.equals(endPoint0y) || pointY.equals(endPoint1y))
                y = true;
              else
                x = false;
  
              //the intersection point did not match any of the endpoints of the diagonal
              if(!x || !y){ 
                outside = true;
                break;
              }
              else{
               outside = false;
              }
               
            }//end of if intersection ! null
    
          }//end of if intersection test

        }
        
        if(!pointInPolygon(diag.get(j).midpoint())){
            totallyOutside = true;
        }
        
        //if the current diagonal passed the tests, it can be returned
        if(!totallyOutside && !outside){ 
          //println(" - " + j ); 
          ret.add(diag.get(j));
        }
     }
     return ret;
   }
  
   void draw(){
     for( Edge e : bdry ){
       e.draw();
     }
   }
   
   
   void addPoint( Point _p ){ 
     p.add( _p );
     if( p.size() == 2 ){
       bdry.add( new Edge( p.get(0), p.get(1) ) );
       bdry.add( new Edge( p.get(1), p.get(0) ) );
     }
     if( p.size() > 2 ){
       bdry.set( bdry.size()-1, new Edge( p.get(p.size()-2), p.get(p.size()-1) ) );
       bdry.add( new Edge( p.get(p.size()-1), p.get(0) ) );
     }
   }
  
  void generateTriangles(){
     if (!isSimple() || !isClosed())
       return;
     
     ArrayList<Edge> diag = getDiagonals();
     int M = diag.size();
     Point v1, v2, v3;
     boolean isTip = false;
     ArrayList<Point> p_copy = new ArrayList<Point>(p);
          
     if (p.size() == 3)
     {
        p_copy.get(0).col = 0;
        p_copy.get(1).col = 1;
        p_copy.get(2).col = 2;
        Triangle t = new Triangle(p_copy.get(0), p_copy.get(1), p_copy.get(2));
        triangles.add(t);
        return;
     }
     
     while(p_copy.size() > 2){//Start while
     //Algorithm for ear-based triangulation
     for(int i=0;i<p_copy.size() && p_copy.size() > 2;)
     {
       v2 = p_copy.get(i);
       if (i == 0)
         v1 = p_copy.get(p_copy.size()-1);
       else
         v1 = p_copy.get(i-1);
       
       if (i == p_copy.size()-1)
         v3 = p_copy.get(0);
       else
         v3 = p_copy.get(i+1);
       
       Edge d = new Edge(v1,v3);
       for(int j=0;j<M;j++)
       {
          Edge d1 = diag.get(j);
          PVector pv0 = PVector.sub( d.p1.p, d.p0.p );
          PVector pv1 = PVector.sub( d1.p1.p, d1.p0.p );
          if (pv0.cross(pv1).z == 0)
          {
              isTip = true;
              break;
          }
       }
       
       if (isTip)
       {
          //Now we need references to the original points in the polygon
          Point v1t = p.get(p.indexOf(v1));
          Point v2t = p.get(p.indexOf(v2));
          Point v3t = p.get(p.indexOf(v3));
          Triangle t = new Triangle(v1t,v2t,v3t);
          triangles.add(t);
          p_copy.remove(i);
          isTip = false;
       }
       else
       {
          i++; 
       }
       
     }
     }//end while
   }
   
   void getDual(){
     ArrayList<Triangle> t_copy = new ArrayList<Triangle>(triangles);
     Node root = new Node(t_copy.get(0));
     t_copy.remove(0);
     
     for(int i=0; i<t_copy.size();){
       println("T_COPY: " + Integer.toString(t_copy.size())); //<>//
       if(root.insert(triangles.get(triangles.indexOf(t_copy.get(i))))){
         t_copy.remove(i);
         i = 0;
       }
       else{
         i++;
       }
     }
     println(Integer.toString(root.size()));
     root.setColors();
     //color any remaining triangles
     for(Triangle t : t_copy){
       t.setColors();
     }
   } //<>// //<>//

}
