
// Class to hold an Axis Aligned Bounding Box
class AABB {

  float minX, maxX;
  float minY, maxY;
  
  AABB( float _minX, float _maxX, float _minY, float _maxY ){
    minX = _minX;
    maxX = _maxX;
    minY = _minY;
    maxY = _maxY;
  }
  
  //checks if the boundaries of the other aabb are within the bounderies of this aabb
  boolean intersectionTest( AABB other ){
    if (this.maxX < other.minX || this.minX > other.maxX || this.maxY < other.minY || this.minY > other.maxY){
      return false;
    }
    return true;
  }
  
}
