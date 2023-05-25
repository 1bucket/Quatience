



class Line {
  // for slope -intercept form
  private float slope;
  private float yInt;
  PVector[] endpts;
  
  // construct a line given 2 points
  public Line(PVector p1, PVector p2) {
    slope = (p1.y - p2.y) / (p1.x - p2.x);
    yInt = p1.y - (slope * p1.x);
    endpts = new PVector[2];
    endpts[0] = p1;
    endpts[1] = p2;
  }
  
  // directly create a line using given slope + yInt
  public Line(float newSlope, float newYInt) {
    slope = newSlope;
    yInt = newYInt;
    endpts = new PVector[2];
  }
  
  public float getSlope() {
    return slope;
  }
  
  public float getYInt() {
    return yInt;
  }
  
  public PVector[] getEndpts() {
    return endpts == null ? null : endpts;
  }
  
  
  
  public float output(float input) {
    return slope * input + yInt;
  }
  
  public float input(float output) {
    return (output - yInt) / slope;
  }
  
  /* returns true if this line and the given line meet within both the given lower
     and upper bounds of their corresponding lines */
  public boolean meetWithinDomain(float l1LowerBound, float l1UpperBound,
                                 Line l2, float l2LowerBound, float l2UpperBound) {
    if (slope == l2.getSlope()) {
      if (yInt == l2.getYInt()) 
        return numInRange(l2LowerBound, l1LowerBound, l1UpperBound) || numInRange(l2UpperBound, l1LowerBound, l1UpperBound);
      else return false;
    }
    else {
      float meetX = (l2.getYInt() - yInt) / (slope - l2.getSlope());
      boolean b = numInRange(meetX, l1LowerBound, l1UpperBound) &&
                  numInRange(meetX, l2LowerBound, l2UpperBound);
      //System.out.println(b);
      return b;
      
    }
  }
  
  
  
  public float distToLine(PVector pt) {
    float nume = Math.abs(slope * pt.x - pt.y + yInt);
    float denom = (float) Math.sqrt(Math.pow(slope, 2) + 1);
    return nume / denom;
  }
  
  // checks if given PVector is (visually) below or on the graph of this line 
  public boolean isBelowLine(PVector pt) {
    return output(pt.x) - pt.y <= 0;
  }
  
  public String toString() {
    return "Slope: " + slope + 
           "\nIntercept: " + yInt + "\n";
  }
}
