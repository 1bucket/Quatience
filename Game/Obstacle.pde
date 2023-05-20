static float obsH;
static float obsW;

class Obstacle {
  
  private PVector pos;
  
  int diff;
  
  public Obstacle (PVector newPos) {
    pos = newPos;
  }
  
  public PVector getApex() {
    return pos.copy().add(obsW / 2, - obsH);
  }
  
  public PVector getPos() {
    return pos;
  }
}
