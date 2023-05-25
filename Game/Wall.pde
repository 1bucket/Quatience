class Wall {
  private PVector pos; // the position of the foot of the wall
  private float wallH;
  private boolean canHit;
  
  public Wall (PVector setPos, float setHeight, boolean dangerStatus) {
    this(setPos, setHeight);
    canHit = dangerStatus;
  }
  
  public Wall (PVector setPos, float setHeight) {
    pos = setPos;
    wallH = setHeight;
    LandTile nextTile = null;
    for (LandTile tile : terrain) {
      if (tile.start.x == pos.x) {
        nextTile = tile;
        break;
      }
    }
    canHit = nextTile != null ? pos.y > nextTile.start.y : false; 
  }
  
  public PVector getPos() {
    return pos;
  }
  
  public float getHeight() {
    return wallH;
  }
  
  public void shift(float xShift) {
    pos.add(- xShift, 0);
  }
  
  public float getTopElev() {
    return pos.y - wallH;
  }
  
  public boolean getDangerStatus() {
    return canHit;
  }
  
  public String toString() {
    return pos + " - " + pos.copy().add(0, -wallH);
  }
}
