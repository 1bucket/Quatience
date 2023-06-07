static final int INVINCIBLE = 0;
static final int DOUBLE_JUMP = 1;
static int powerupRadius;

class Powerup extends Displayable {
  private int powerVar;
  
  public Powerup(PVector pos, int powerVar) {
    super(pos);
    this.powerVar = powerVar;
  }
  
  public int getPowerVar() {
    return powerVar;
  }
}
