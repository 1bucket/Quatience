static int tileWidth;

class LandTile {
  PVector start, end;
  boolean hasObstacle;
  //Obstacle obs;
  int diff;
  
  color col;
  
  public LandTile(PVector newStart, PVector newEnd, boolean willHaveObstacle) {
    start = newStart;
    end = newEnd;
    hasObstacle = willHaveObstacle;
    //if (hasObstacle) obs = new Obstacle(new PVector((start.x + end.x) / 2,
    //                                                (start.y + start.y) / 2));
  }
  
  public LandTile(PVector newStart, PVector newEnd, boolean willHaveObstacle, color c) {
    start = newStart;
    end = newEnd;
    hasObstacle = willHaveObstacle;
    //if (hasObstacle) obs = new Obstacle(new PVector((start.x + end.x) / 2,
                                                    //(start.y + start.y) / 2));
    col = c;
  }
  
  public void shift(int xShift) {
    start.add(-xShift, 0);
    end.add(-xShift, 0);
    diff += xShift;
  }
  
  public PVector getObsApex() {
    return hasObstacle ? new PVector(start.x + tileWidth / 2, 
                                     start.y - (float) Math.sqrt(3) / 2 * tileWidth )
                       : null;
  }
  
  public String toString() {
    return "Start: " + start.x + ", " + start.y + "\n" +
           "End: " + end.x + ", " + end.y + "\n";
    
  }
}
