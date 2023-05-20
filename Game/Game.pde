static int tileWidth;

class LandTile {
  PVector start, end;
  boolean hasObstacle;
  Obstacle obs;
  int diff;
  
  color col;
  
  public LandTile(PVector newStart, PVector newEnd, boolean willHaveObstacle) {
    start = newStart;
    end = newEnd;
    hasObstacle = willHaveObstacle;
    if (hasObstacle) {
      obs = new Obstacle(new PVector(start.x, start.y));
      obstacles.add(obs);
    }
  }
  
   public LandTile(PVector newStart, PVector newEnd, boolean willHaveObstacle, color c) {
    this(newStart, newEnd, willHaveObstacle);
    col = c;
  }
  
  public Obstacle getObs() {
    return obs;
  }
  
  public void shift(int xShift) {
    start.x -= xShift;
    end.x -= xShift;
    if (hasObstacle) {
      obs.pos.x -= xShift;
      obs.diff += xShift;
    }
    diff += xShift;
  }
  
  public PVector getObsApex() {
    if (hasObstacle) return start.copy().add(tileWidth / 2, - (float) Math.sqrt(3) / 2 * tileWidth);
    else return null;
  }
  
  public String toString() {
    return "Start: " + start.x + ", " + start.y + "\n" +
           "End: " + end.x + ", " + end.y + "\n";
    
  }
}
