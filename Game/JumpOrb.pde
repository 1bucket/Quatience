static int radius;

class JumpOrb {
  private PVector pos;
  
  public JumpOrb(PVector pos) {
    this.pos = pos;
  }
  
  public PVector getPos() {
    return pos;
  }
  
  public void shift(int xShift) {
    pos.add(-xShift, 0);
  }
}
