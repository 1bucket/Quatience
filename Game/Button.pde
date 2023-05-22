class Button {
  private PVector pos;
  private String text;
  private int bWidth, bHeight;
  
  public Button(PVector setPos, String setText, int setWidth, int setHeight) {
    pos = setPos;
    text = setText;
    bWidth = setWidth;
    bHeight = setHeight;
  }
  
  public void displayButton() {
    rectMode(CENTER);
    fill(74, 153, 255);
    rect(pos.x, pos.y, bWidth, bHeight);
    fill(0, 0, 0);
    textSize(30);
    textAlign(CENTER);
    text(text, pos.x, pos.y + 10);
  }
  
  public boolean isMouseOnButton() {
    float upper = pos.y - bHeight / 2;
    float lower = pos.y + bHeight / 2;
    float left = pos.x - bWidth / 2;
    float right = pos.x + bWidth / 2;
    return mouseX >= left && mouseX <= right && mouseY > upper && mouseY < lower;
  }
  
  public String getText() {
    return text;
  }
    
}
