static int tileWidth;
static final int ABOVE = 0;
static final int BELOW = 1;

class LandTile extends Structure {
  PVector start, end;
  boolean hasObstacle;
  boolean hasJumpPad;
  int obsPos;
  //Obstacle obs;
  //int diff;
  
  color col;
  
  public LandTile(PVector newStart, PVector newEnd, boolean willHaveObstacle, boolean willHaveJumpPad, int obsOrient) {
    super(new PVector((newStart.x + newEnd.x) / 2, newStart.y));
    start = newStart;
    end = newEnd;
    hasObstacle = willHaveObstacle;
    hasJumpPad = willHaveJumpPad;
    obsPos = obsOrient;
  }
  
  public LandTile(PVector newStart, PVector newEnd, boolean willHaveObstacle, color c, boolean willHaveJumpPad, int obsOrient) {
    this(newStart, newEnd, willHaveObstacle, willHaveJumpPad, obsOrient);
    col = c;
  }
  
  public void shift(int xShift) {
    super.shift(xShift);
    start.add(-xShift, 0);
    end.add(-xShift, 0);
    //diff += xShift;
  }
  
  public PVector getObsApex() {
    if (hasObstacle) {
      if (obsPos == ABOVE)
        return new PVector(start.x + tileWidth / 2, start.y - (float) Math.sqrt(3) / 2 * tileWidth );
      else return new PVector(start.x + tileWidth / 2, start.y + 5 + (float) sqrt(3) / 2 * tileWidth);
    }
    else return null;
  }
  
  public String toString() {
    return "Start: " + start.x + ", " + start.y + "\n" +
           "End: " + end.x + ", " + end.y + "\n";
    
  }
}
