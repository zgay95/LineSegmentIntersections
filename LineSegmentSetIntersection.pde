

// The naive O(n^2) method for calucating the intersections of a set of line segments.  
public static void NaiveLineSegmentSetIntersection( ArrayList<Edge> input_edges, ArrayList<Point> output_intersections ){
  output_intersections.clear();
  for( int i = 0; i < input_edges.size(); i++ ){
    for(int j = i+1; j < input_edges.size(); j++ ){
      Point intersection = input_edges.get(i).intersectionPoint(input_edges.get(j));
      if(intersection != null)
        output_intersections.add(intersection);
    }
  }
}


// The naive O(n^2) method for calucating the intersections of a set of line segments that uses the optimized line intersection.  
public static void OptimizedLineSegmentSetIntersection( ArrayList<Edge> input_edges, ArrayList<Point> output_intersections ){
  output_intersections.clear();
  for( int i = 0; i < input_edges.size(); i++ ){
    for(int j = i+1; j < input_edges.size(); j++ ){
      Point intersection = input_edges.get(i).optimizedIntersectionPoint(input_edges.get(j));
      if(intersection != null)
        output_intersections.add(intersection);
    }
  }
}


public static void OptimizedLineSegmentSetIntersectionAABB( ArrayList<Edge> input_edges, ArrayList<Point> output_intersections ){
  output_intersections.clear();
  ArrayList<Edge> CurrentAABBs = new ArrayList<Edge>();
  ArrayList<Edge> MinY = new ArrayList<Edge>(input_edges);
  //Sort the arraylist by max y value to determine which and the order of rectangles are to be added to the Q
  Collections.sort(input_edges, new Comparator<Edge>() {@Override public int compare(Edge Edge1, Edge Edge2) {
                //println(Float.compare(Edge1.aabb.maxY, Edge2.aabb.maxY));
                return Float.compare(Edge1.aabb.maxY, Edge2.aabb.maxY); }});
  Collections.sort(MinY, new Comparator<Edge>() {@Override public int compare(Edge Edge1, Edge Edge2) {
                //println(Float.compare(Edge1.aabb.minY, Edge2.aabb.minY));
                return Float.compare(Edge1.aabb.minY, Edge2.aabb.minY); }});             
  Collections.reverse(input_edges);
  Collections.reverse(MinY);
  //For every add event in the list
  for( int i = 0; i < input_edges.size(); i++ ){
    //println("currentValues:" + input_edges.get(i).aabb.maxY + "      MinY:"+ MinY.get(0).aabb.minY);
    //if the next remove event is next compare the --  Highest MinY value to the current MaxY value
    if(MinY.get(0).aabb.minY > input_edges.get(i).aabb.maxY){
      for( int j = 0; j < CurrentAABBs.size(); j++ ){
        //remove the aabb from the current list of active aabbs and remove the lowest y as that line segment isnt active anymore
        if(CurrentAABBs.get(j) == MinY.get(0)){
          //println("Removing coord:" + CurrentAABBs.get(j).aabb.minY + "   currenty: " + input_edges.get(i).aabb.maxY + "      MinY:"+ MinY.get(0).aabb.minY);
          CurrentAABBs.remove(j);
          MinY.remove(0);
          break;
        }
      }
    }
    //do an intersection test for all active aabbs and the new one to be added, also add the new rectangle to active aabbs
    for( int k = 0; k < CurrentAABBs.size(); k++ ){
      //println("result: " + input_edges.get(i).aabb.intersectionTest(CurrentAABBs.get(k).aabb) + "     "+ input_edges.get(i).aabb.minY + "    " + CurrentAABBs.get(k).aabb.maxY);
      if(input_edges.get(i).aabb.intersectionTest(CurrentAABBs.get(k).aabb)){
        Point intersection = input_edges.get(i).intersectionPoint(CurrentAABBs.get(k));
        if(intersection != null){
          //println("Intersection:" + intersection.getX() + "    " + intersection.getY());
          //println("Intersection:");
          output_intersections.add(intersection);
        }
      }
    }      
    CurrentAABBs.add(input_edges.get(i));    
  }
} 
