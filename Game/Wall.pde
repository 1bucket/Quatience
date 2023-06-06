class Wall extends Displayable {
  //private PVector pos; // the position of the foot of the wall
  private float wallH;
  //private boolean canHit;
  
  //public Wall (PVector setPos, float setHeight, boolean dangerStatus) {
  //  this(setPos, setHeight);
  //  //canHit = dangerStatus; // true if wall is deadly, false otherwise
  //}
  
  public Wall (PVector setPos, float setHeight) {
    super(setPos);
    wallH = setHeight;
    //LandTile nextTile = null;
    //for (LandTile tile : terrain) {
    //  if (tile.start.x == getPos().x) {  
    //    nextTile = tile;
    //    break;
    //  }
    //}
    //canHit = nextTile != null ? getPos().y > nextTile.start.y : false; 
  }
  
  public float getHeight() {
    return wallH;
  }
  
  public float getTopElev() {
    return getPos().y - wallH;
  }
  
  //public boolean getDangerStatus() {
  //  return canHit;
  //}
  
  public String toString() {
    return getPos() + " - " + getPos().copy().add(0, -wallH);
  }
}
