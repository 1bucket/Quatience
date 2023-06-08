static int tileWidth;
static final int NONE = 0;
static final int ABOVE = 1;
static final int BELOW = 2;

class LandTile extends Displayable {
  PVector start, end;
  private boolean hasJumpPad;
  private int obsStatus;
  private boolean isMidair;

  public LandTile(PVector newStart, PVector newEnd,  boolean willHaveJumpPad, int obsOrient, boolean isMidair) {
    super(new PVector((newStart.x + newEnd.x) / 2, isMidair ? newStart.y - 5 : newStart.y));
    start = isMidair ? newStart.add(0, -10) : newStart;
    end = isMidair ? newEnd.add(0, -10) : newEnd;
    hasJumpPad = willHaveJumpPad;
    obsStatus = obsOrient;
    this.isMidair = isMidair;
    LandTile tileBefore = tileBefore(this);
    if (isMidair && tileBefore == null) { 
      walls.add(new Wall(start.copy().add(0, 10), 10));
    }
  }
  
  public void shift(int xShift) {
    super.shift(xShift);
    start.add(-xShift, 0);
    end.add(-xShift, 0);
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
  
  public LandTile copy() {
    return new LandTile(start.copy(), end.copy(), hasJumpPad, obsStatus, isMidair);
  }
  
  public String toString() {
    return "Start: " + start.x + ", " + start.y + "\n" +
           "End: " + end.x + ", " + end.y + "\n";
    
  }
}
