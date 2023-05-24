class Player { //<>// //<>// //<>//
  //private PVector[] corners;
  private PVector center;
  private int speedx;
  private int speedy;
  private float rotAng;
  
  
  public Player(PVector center, int spdX) {
    this.center = center;
    rotAng = PI / 4;
    speedx = spdX;
    speedy = 0;
  }
  
  public void setSpeed(int spdX, int spdY) {
    speedx = spdX;
    speedy = spdY;
  }
  
  public int getSpdX() {
    return speedx;
  }
  
  public int getSpdY() {
    return speedy;
  }
  
  public float getRotAng() {
    return rotAng;
  }
  
  public void setSpdX(int spdX) {
    speedx = spdX;
  }
  
  public void setSpdY(int spdY) {
    speedy = spdY;
  }
  
  public void setRotAng(float newAng) {
    rotAng = newAng;
  }
  
  public PVector getCenter() {
    return center;
  }
  
  public PVector[] getCorners() {
    PVector[] corners = new PVector[4];
    for (int index = 0; index < corners.length; index++) {
      float trueAng = rotAng + index * PI / 2;
      float cornerX = center.x + (tileWidth / sqrt(2) * cos(trueAng));
      float cornerY = center.y + (tileWidth / sqrt(2) * sin(trueAng));
      
      
      corners[index] = new PVector(cornerX, cornerY); 
      //LandTile tileUnder = Game.tileBelow(corners[index]);
    }
    return corners;
  }
  
  public void jump() {
    speedy = 20;
  } //<>// //<>//
  
  
}
