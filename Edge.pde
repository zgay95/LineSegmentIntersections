

class Edge{
  
   Point p0,p1;
   AABB aabb;
   
   Edge(Point _p0, Point _p1 ){
     p0 = _p0;
     p1 = _p1;
     aabb = new AABB(min(_p0.getX(),_p1.getX()),max(_p0.getX(),_p1.getX()),min(_p0.getY(),_p1.getY()),max(_p0.getY(),_p1.getY()));
   }
   
   void draw(){
     line( p0.p.x, p0.p.y, 
           p1.p.x, p1.p.y );
   }
   
   AABB getAABB(){
     return aabb;
   }
   
   boolean intersectionTest( Edge other ){
     PVector v1 = PVector.sub( other.p0.p, p0.p );
     PVector v2 = PVector.sub( p1.p, p0.p );
     PVector v3 = PVector.sub( other.p1.p, p0.p );
     
     float z1 = v1.cross(v2).z;
     float z2 = v2.cross(v3).z;
     
     if( (z1*z2)<0 ) return false;  

     PVector v4 = PVector.sub( p0.p, other.p0.p );
     PVector v5 = PVector.sub( other.p1.p, other.p0.p );
     PVector v6 = PVector.sub( p1.p, other.p0.p );

     float z3 = v4.cross(v5).z;
     float z4 = v5.cross(v6).z;
     
     if( (z3*z4<0) ) return false;  
     
     return true;  
   }
   
   Point intersectionPoint( Edge other ){  
     //Calculate the common denominator in both t and q formulas
     float denom = (this.p1.getX() - this.p0.getX()) * (-other.p1.getY() + other.p0.getY()) + (-this.p1.getY() + this.p0.getY()) * (-other.p1.getX() + other.p0.getX());
     //check if the demoninator equals 0, this will throw an error if not checked.
     if (denom == 0){
     return null;
     }
     //calculate t to determine how far down the P0 -> P1 line segment the intersection point could be
     float t0 = ((other.p0.getX() - this.p0.getX()) * (-other.p1.getY() + other.p0.getY()) + (other.p1.getX() - other.p0.getX()) * (other.p0.getY() - this.p0.getY()))/ denom;
     
     //calculate q to determine how far down the P2 -> P3 line segment the intersection point could be
     float q0 = ((this.p1.getX() - this.p0.getX()) * (other.p0.getY() - this.p0.getY()) + (-other.p0.getX() + this.p0.getX()) * (this.p1.getY() - this.p0.getY()))/ denom;
     
     // Check if t and q are both between 0 & 1. They must lie between these values to be considered on the line segments. Return null if they are not
     if (t0 < 0 || t0 > 1 || q0 < 0 || q0 > 1) {
        return null;
    }
    
    //calculate the exact coords of intersection
    float x = (this.p0.getX() + (t0 * (this.p1.getX() - this.p0.getX())));
    float y = (this.p0.getY() + (t0 * (this.p1.getY() - this.p0.getY())));
    //We have made it this far so there must be an intersection point on the line segments.
    //println("niave Intersection:" + x + "    " + y);
     return new Point(x,y);
   }
   
   Point optimizedIntersectionPoint( Edge other ){ //by slope-intecept form and checking if intersecting point is within the proper range    
    //calculate the slopes of each line segment
     //float m1 = ((this.p1.getY() - this.p0.getY()) / (this.p1.getX() - this.p0.getX()));
     //float m2 = ((other.p1.getY() - other.p0.getY()) / (other.p1.getX() - other.p0.getX()));
     
     //calculate the y-intercept of each line segment
     float b1 = this.p0.getY() - (this.p0.getX() * ((this.p1.getY() - this.p0.getY()) / (this.p1.getX() - this.p0.getX())));
     float b2 = other.p0.getY() - (other.p0.getX() * ((other.p1.getY() - other.p0.getY()) / (other.p1.getX() - other.p0.getX())));
      
     //calculate intersection point
     float x = -(b1 - b2) / (((this.p1.getY() - this.p0.getY()) / (this.p1.getX() - this.p0.getX())) - ((other.p1.getY() - other.p0.getY()) / (other.p1.getX() - other.p0.getX())));
     
     if ( x > min(this.p0.getX(), this.p1.getX()) && x < max(this.p0.getX(), this.p1.getX()) && x > min(other.p0.getX(), other.p1.getX()) && x < max(other.p0.getX(), other.p1.getX())){
       float y = (((this.p1.getY() - this.p0.getY()) / (this.p1.getX() - this.p0.getX())) * x) + b1;
       return new Point(x,y);
     }
    return null;
   }
}
