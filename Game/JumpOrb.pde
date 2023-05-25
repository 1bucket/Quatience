static int radius;

class JumpOrb extends Structure {
  
  public JumpOrb(PVector pos) {
    super(pos);
  }
  
  public void shift(int xShift) {
    getPos().add(-xShift, 0);
  }
}
