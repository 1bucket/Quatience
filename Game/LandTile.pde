static int tileWidth;

class LandTile {
  PVector start, end;
  boolean hasObstacle;
  Obstacle obs;
  
  public LandTile(PVector newStart, PVector newEnd, boolean willHaveObstacle) {
    start = newStart;
    end = newEnd;
    hasObstacle = willHaveObstacle;
    if (hasObstacle) obs = new Obstacle(new PVector((start.x + end.x) / 2,
                                                    (start.y + start.y) / 2));
  }
  
  public void shift(int xShift) {
    start.add(-xShift, 0);
    end.add(-xShift, 0);
  }
  
  public String toString() {
    return "Start: " + start.x + ", " + start.y + "\n" +
           "End: " + end.x + ", " + end.y + "\n";
    
  }
}
