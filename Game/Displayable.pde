class Displayable {
  private PVector pos;
  
  public Displayable(PVector setPos) {
    pos = setPos;
  }
  
  public PVector getPos() {
    return pos;
  }
  
  public void shift(int xShift) {
    pos.add(-xShift, 0);
  }
}
