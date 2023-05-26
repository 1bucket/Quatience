static int tileWidth;
static final int NONE = 0;
static final int ABOVE = 1;
static final int BELOW = 2;

class LandTile extends Structure {
  PVector start, end;
  //boolean hasObstacle;
  boolean hasJumpPad;
  private int obsStatus;
  boolean isMidair;
  //Obstacle obs;
  //int diff;
  
  color col;
  
  public LandTile(PVector newStart, PVector newEnd,  boolean willHaveJumpPad, int obsOrient, boolean isMidair) {
    super(new PVector((newStart.x + newEnd.x) / 2, isMidair ? newStart.y - 5 : newStart.y));
    start = isMidair ? newStart.add(0, -5) : newStart;
    end = isMidair ? newEnd.add(0, -5) : newEnd;
    //hasObstacle = willHaveObstacle;
    hasJumpPad = willHaveJumpPad;
    obsStatus = obsOrient;
    this.isMidair = isMidair;
    if (isMidair) {
      walls.add(new Wall(start.copy().add(0, 10), 10));
      walls.add(new Wall(end.copy().add(0, 10), 10));
    }
  }
  
  public LandTile(PVector newStart, PVector newEnd, color c, boolean willHaveJumpPad, int obsOrient, boolean isMidAir) {
    this(newStart, newEnd, willHaveJumpPad, obsOrient, isMidAir);
    col = c;
  }
  
  public void shift(int xShift) {
    super.shift(xShift);
    start.add(-xShift, 0);
    end.add(-xShift, 0);
    //diff += xShift;
  }
  
  public int getObsStatus() {
    return obsStatus;
  }
  
  public PVector getObsApex() {
    if (obsStatus == ABOVE)
      return new PVector(start.x + tileWidth / 2, start.y - (float) Math.sqrt(3) / 2 * tileWidth );
    else if (obsStatus == BELOW) return new PVector(start.x + tileWidth / 2, start.y + 10 + (float) sqrt(3) / 2 * tileWidth);
    else return null;
  }
  
  public String toString() {
    return "Start: " + start.x + ", " + start.y + "\n" +
           "End: " + end.x + ", " + end.y + "\n";
    
  }
}
