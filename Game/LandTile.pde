static int tileWidth;

class LandTile extends Structure {
  PVector start, end;
  boolean hasObstacle;
  boolean hasJumpPad;
  //Obstacle obs;
  //int diff;
  
  color col;
  
  public LandTile(PVector newStart, PVector newEnd, boolean willHaveObstacle, boolean willHaveJumpPad) {
    super(new PVector((newStart.x + newEnd.x) / 2, newStart.y));
    start = newStart;
    end = newEnd;
    hasObstacle = willHaveObstacle;
    hasJumpPad = willHaveJumpPad;
  }
  
  public LandTile(PVector newStart, PVector newEnd, boolean willHaveObstacle, color c, boolean willHaveJumpPad) {
    this(newStart, newEnd, willHaveObstacle, willHaveJumpPad);
    col = c;
  }
  
  public void shift(int xShift) {
    super.shift(xShift);
    start.add(-xShift, 0);
    end.add(-xShift, 0);
    //diff += xShift;
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
