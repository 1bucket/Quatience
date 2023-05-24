class Wall {
  private PVector pos; // the position of the foot of the wall
  private float wallH;
  
  public Wall (PVector setPos, float setHeight) {
    pos = setPos;
    wallH = setHeight;
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
  
  public String toString() {
    return pos + " - " + pos.copy().add(0, -wallH);
  }
}
