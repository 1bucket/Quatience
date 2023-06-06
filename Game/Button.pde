class Button extends Displayable{
  private String text;
  private int bWidth, bHeight;
  
  public Button(PVector setPos, String setText, int setWidth, int setHeight) {
    super(setPos);
    //pos = setPos;
    text = setText;
    bWidth = setWidth;
    bHeight = setHeight;
  }
  
  public void displayButton() {
    //rectMode(CENTER);
    stroke(0);
    color bColor = isMouseOnButton() ? color(red(themeColor) + 86, green(themeColor) + 152, blue(themeColor) + 34) 
                                     : color(red(themeColor) + 14, green(themeColor) + 34, blue(themeColor) + 34);
    fill(bColor);
    rect(getPos().x - bWidth / 2, getPos().y - bHeight / 2, bWidth, bHeight);
    fill(0, 0, 0);
    textSize(30);
    textAlign(CENTER);
    text(text, getPos().x, getPos().y + 10);
  }
  
  public boolean isMouseOnButton() {
    float upper = getPos().y - bHeight / 2;
    float lower = getPos().y + bHeight / 2;
    float left = getPos().x - bWidth / 2;
    float right = getPos().x + bWidth / 2;
    return mouseX >= left && mouseX <= right && mouseY > upper && mouseY < lower;
  }
  
  public String getText() {
    return text;
  }
    
}
