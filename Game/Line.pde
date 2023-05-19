



class Line {
  // for slope -intercept form
  private float slope;
  private float yInt;
  
  // for general form
  
  // construct a line given 2 points
  public Line(PVector p1, PVector p2) {
    slope = (p1.y - p2.y) / (p1.x - p2.x);
    yInt = p1.y - (slope * p1.x);
  }
  
  // directly create a line using given slope + yInt
  public Line(float newSlope, float newYInt) {
    slope = newSlope;
    yInt = newYInt;
  }
  
  public float getSlope() {
    return slope;
  }
  
  public float getYInt() {
    return yInt;
  }
  
  public float output(float input) {
    return slope * input + yInt;
  }
  
  public float input(float output) {
    return (output - yInt) / slope;
  }
  
  public boolean meetWithinLimit(Line l2, int lowerBound, int upperBound) {
    float meetX = (l2.getYInt() - yInt) / (slope - l2.getSlope());
    return (meetX >= lowerBound && meetX <= upperBound);
  }
  
  public float distToLine(PVector pt) {
    float nume = Math.abs(slope * pt.x - pt.y + yInt);
    float denom = (float) Math.sqrt(Math.pow(slope, 2) + 1);
    return nume / denom;
  }
}
