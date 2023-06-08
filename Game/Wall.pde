class Wall extends Displayable {

  private float wallH;
  
  public Wall (PVector setPos, float setHeight) {
    super(setPos);
    wallH = setHeight;
  }
  
  public float getHeight() {
    return wallH;
  }
  
  public float getTopElev() {
    return getPos().y - wallH;
  }
 
  public String toString() {
    return getPos() + " - " + getPos().copy().add(0, -wallH);
  }
}
