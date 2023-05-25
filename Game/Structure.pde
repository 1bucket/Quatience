class Structure {
  private PVector pos;
  
  public Structure(PVector setPos) {
    pos = setPos;
  }
  
  public PVector getPos() {
    return pos;
  }
  
  public void shift(int xShift) {
    pos.add(-xShift, 0);
  }
}
