boolean pause;
int difficulty;
final int EASY = 0;
final int MEDIUM = 1;
final int HARD = 2;
int score = 0;
int elev;
boolean gameOver;
ArrayList<Button> buttons;

Player p;
color pCol;
int curSpd;
int exploSize;
int opacity;

ArrayList<LandTile> terrain;
ArrayList<Wall> walls;
ArrayList<JumpOrb> jumpOrbs;
LandTile startTile;

void setup() {
  size(1200, 600);
  newGame(); 
  //frameRate(20);
  //Line test1 = new Line(2, 0);
  //Line test3 = new Line(new PVector(1, 2), new PVector(0, 1));
  //PVector[] tests = test3.getEndpts();
  //sortPtsY(tests);
  //for (PVector endpt : tests) System.out.println(endpt);
  //Line test2 = new Line(1, 1);
  //System.out.println(test1.meetWithinDomain(2, 8, test2, -5, 2));
}

void newGame() {
  gameOver = false;
  pause = false;
  score = 0;
  difficulty = EASY;
  pause = false;
  
  
  tileWidth = width / 40;
  elev = height * 2 / 3;
  radius = 20;
  
  pCol = color(32, 129, 255);
  curSpd = 7;
  
  // for death animation
  opacity = 256;
  exploSize = (int) (tileWidth * sqrt(2));
  
  buttons = new ArrayList<Button>();
  walls = new ArrayList<Wall>();
  
  terrain = new ArrayList<LandTile>();
  startTile = new LandTile(new PVector (0, elev), new PVector(width, elev), false, color(255, 255, 255), false);
  terrain.add(startTile);
  walls = new ArrayList<Wall>();
  
  jumpOrbs = new ArrayList<JumpOrb>();
  jumpOrbs.add(new JumpOrb(new PVector(width * .75, 325)));
  
  PVector testBegin = startTile.end.copy().add(0, -60);
  PVector testEnd = testBegin.copy().add(tileWidth * 4, 0);
  //System.out.println(testBegin);
  //System.out.println(testEnd);
  LandTile testTile = new LandTile(testBegin, testEnd, false, color(255, 0, 0), true);
  terrain.add(testTile);
  walls.add(new Wall(testTile.start.copy().add(0, 30), 30));

  p = new Player(new PVector(180, elev - tileWidth / 2), curSpd);
  //stroke(0, 0, 0);
  
  
}

void drawOrbs() {
  for (JumpOrb orb : jumpOrbs) {
    //System.out.println("hello");
    PVector pos = orb.getPos();
    circle(pos.x, pos.y, radius * 2);
  }
}

void drawPlayer() {
  noStroke();
  fill(pCol);
  if (gameOver) {
    // death animation
    fill(pCol, opacity -= 20);
    circle(p.getCenter().x, p.getCenter().y, exploSize += 5);
  }
  else {
    PVector[] corners = p.getCorners();
    for (int index = 0; index < corners.length; index++) {
      PVector corner = corners[index];
      LandTile underTile = tileBelow(corner);
      Line surface = new Line (underTile.start, underTile.end);
      corners[index].set(corners[index].x, constrain(corner.y, 0, surface.output(corner.x)));
    }
    quad(corners[0].x, corners[0].y, corners[1].x, corners[1].y,
         corners[2].x, corners[2].y, corners[3].x, corners[3].y);
  }
}


void drawTerrain() {
  // modified loop to incorporate changes in elevation
  for (LandTile tile : terrain) {
    stroke(tile.col);
    line(tile.start.x, tile.start.y, tile.end.x, tile.end.y);
    if (tile.hasObstacle){
      fill(tile.col);
      PVector obsApex = tile.getObsApex();
      triangle(tile.start.x, tile.start.y,
               tile.start.x + tileWidth, tile.start.y,
               obsApex.x, obsApex.y);
    }
    else if (tile.hasJumpPad) {
      fill(tile.col);
      //System.out.println(tile.start.x);
      rect(tile.start.x, tile.start.y - 5, Math.abs(tile.start.x - tile.end.x), 5);
    }
    //int nextInd = index + 1;
    //if (nextInd < terrain.size()) {
    //  LandTile next = terrain.get(nextInd);
    //  if (next.start.y != tile.end.y) {
    //    line(tile.end.x, tile.end.y, next.start.x, next.start.y);
    //  }
    //}
  }
  
  for (Wall wall : walls) {
    stroke(0, 0, 0);
    //System.out.println(wall);
    //System.out.println(terrain.get(1));
    PVector pos = wall.getPos();
    line(pos.x, pos.y, pos.x, pos.y - wall.getHeight());
  }
  // for indicating end of start tile
  //line(startTile.end.x, elev, startTile.end.x, 0);
  stroke(200, 150, 200);
}

void displayScore() {
  fill(255, 255, 255);
  textSize(40);
  textAlign(CENTER);
  text(score, width / 2, 40);
}

void displayAllButtons() {
  for (Button button : buttons) button.displayButton();
}

void activateButton() {
  for (Button button : buttons)  {
    if (mousePressed & button.isMouseOnButton()) {
      if (button.getText().equals("Resume")) 
        resumeGame();
      else if (button.getText().equals("Restart")) {
        newGame();
      }
    }
  }
}

void draw() {
  background(255, 222, 131);
  if (! gameOver && ! pause) {
    score += 5;
    movePlayer();
  }
  displayScore();
  drawTerrain();
  drawPlayer();
  drawOrbs();
  displayAllButtons();
  activateButton();
  
  //if (pause) pauseGame();
  //else p.setSpdX(curSpd);
}



void movePlayer() {
    
  // shift terrain left to produce illusion of character movement
  for (LandTile tile : terrain) tile.shift(p.getSpdX());
  for (Wall wall : walls) wall.shift(p.getSpdX());
  for (JumpOrb orb : jumpOrbs) orb.shift(p.getSpdX());
  
  // continuously generate new terrain as the game runs
  if (walls.size() > 0) {
    for (int index = 0; index < walls.size(); index++) {
      if (walls.get(index).getPos().x < 0) {
        walls.remove(index);
        index--;
      }
    }
  }
  
  if (jumpOrbs.size() > 0) {
    for (int index = 0; index < jumpOrbs.size(); index++) {
      if (jumpOrbs.get(index).getPos().x < 0) {
        jumpOrbs.remove(index--);
      }
    }
  }
  
  
  
  LandTile curTile = terrain.get(0);
  if (curTile.end.x < 0) terrain.remove(curTile);
  LandTile lastTile = terrain.get(terrain.size() - 1);
  if (terrain.size() < 45) {
      boolean willHaveObs = Math.random() < 0.1 ? true : false;
      //willHaveObs = false;
      LandTile next = new LandTile(lastTile.end.copy().set(lastTile.end.x, elev), lastTile.end.copy().set(lastTile.end.x + tileWidth, elev), willHaveObs, 
                                   color((int) (Math.random() * 255), (int) (Math.random() * 255), (int) (Math.random() * 255)), false);
      terrain.add(next);
      if (next.start.y != lastTile.end.y) walls.add(new Wall(next.start.copy(), Math.abs(lastTile.end.y - next.end.y))); 
  }
  
  // vertical player movement
  PVector pCenter = p.getCenter();
  pCenter.add(0, - p.getSpdY());
  checkCollision();
}

void checkCollision() {
  PVector[] corners = p.getCorners();
  
  PVector pCenter = p.getCenter();
  
  // collisions against ground and obstacles
  int grounded = 0;
  for (PVector corner : corners) {
    
    // wall collision
    for (Wall wall : walls) {
      PVector wallPos = wall.getPos();
      if (wall.getDangerStatus() &&
          pCenter.x < wallPos.x &&
          numInRange(corner.x, wallPos.x, wallPos.x + tileWidth) && 
          numInRange(corner.y, wall.getTopElev(), wallPos.y))
        endGame();
    }
    
    // ground and obstacle collision
    LandTile tileUnder = tileBelow(corner);
    if (tileUnder.hasObstacle) {
      PVector apex = tileUnder.getObsApex();
      PVector endPt = corner.x > tileUnder.start.x + tileWidth / 2 ? tileUnder.end : tileUnder.start;
      Line obsSurface = new Line(apex, endPt);
      if (obsSurface.output(corner.x) - corner.y <= 0) endGame();            
    }
    if (corner.y >= tileUnder.start.y) {
      if (tileUnder.hasJumpPad) {
        p.jump(MAJOR);
        grounded = 0;
      }
      grounded++;
    }
    
  }
  if (grounded >= 1 && p.getSpdY() <= 0) {
    p.setRotAng(PI / 4);
    p.setSpdY(0);
    if (grounded == 2) pCenter.set(pCenter.x, tileBelow(pCenter).start.y - tileWidth / 2);
  }
  else {
    gravity();
    p.setRotAng(p.getRotAng() + PI / 45);
  }
}

void gravity() {
  p.setSpdY(p.getSpdY() - 1);
}

LandTile tileBelow(PVector corner) {
  for (LandTile tile : terrain) {
    if (corner.x >= tile.start.x && corner.x <= tile.end.x)
      return tile;
  }
  return null;
}

// returns true if the player is within the vicinity of 
boolean checkOrbCollision() {
  PVector pCenter = p.getCenter();
  for (JumpOrb orb : jumpOrbs) {
    //System.out.println(pCenter.dist(orb.getPos()));
    if (pCenter.dist(orb.getPos()) < radius + 20) {
      System.out.println("hello");
      return true;
    }
  }
  return false;
}
ArrayList<PVector> cornersOnGround() {
  ArrayList<PVector> grounded = new ArrayList<PVector>();
  for (PVector corner : p.getCorners()) {
    LandTile underTile = tileBelow(corner);
    //Line surface = new Line(underTile.start, underTile.end);
    //if (surface.output(corner.x) - corner.y <= 0) grounded.add(corner);
    if (corner.y >= underTile.start.y - 1) grounded.add(corner);
  }
  return grounded;
}

void sortPtsX(PVector[] pts) {
  PVector pt0 = pts[0];
  PVector pt1 = pts[1];
  if (pt0.x > pt1.x) {
    pts[0] = pt1;
    pts[1] = pt0;
  }
}
  
void sortPtsY(PVector[] pts) {
  PVector pt0 = pts[0];
  PVector pt1 = pts[1];
  if (pt0.y > pt1.y) {
    pts[0] = pt1;
    pts[1] = pt0;
  }
}

boolean numInRange(float test, float lowerBound, float upperBound) {
  return test >= lowerBound && test < upperBound;
}

void endGame() {
  gameOver = true;
  p.setSpdX(0);
  //System.out.println("bonk");
}

void pauseGame() {
  pause = true;
  // freeze game
  //p.setSpdX(0);
  
  // build pause menu
  int bWidth = 120;
  int bHeight = 75;
  PVector midpt = new PVector(width / 2, height * .75);
  Button resume = new Button(midpt.copy().add(-150, 0), "Resume", bWidth, bHeight);
  //resume.displayButton();
  Button restart = new Button(midpt.copy().add(150, 0), "Restart", bWidth, bHeight);
  buttons.add(resume);
  buttons.add(restart);
  //System.out.println("paused");
}

void resumeGame() {
  pause = false;
  buttons = new ArrayList<Button>();
}

void keyPressed() {
  if (key == ' ' && ! gameOver && ! pause) {
    if (cornersOnGround().size() == 2) p.jump(NORMAL);
    else if (checkOrbCollision()) p.jump(MINOR);
  }
  if (gameOver && key == 'a') {
    newGame();
  }
  if (key == 'r' && pause) newGame();
  if (key == 'q' && ! gameOver) {
    if (pause) resumeGame();
    else pauseGame();
  }
}
  
