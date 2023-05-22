boolean pause;
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
LandTile startTile;

void setup() {
  size(1200, 600);
  
  
  curSpd = 2;
  tileWidth = width / 40;
  elev = height * 2 / 3;
  pause = false;
  
  pCol = color(32, 129, 255);
  
  // for death animation
  opacity = 256;
  exploSize = (int) (tileWidth * sqrt(2));
  
  terrain = new ArrayList<LandTile>();
  startTile = new LandTile(new PVector (0, elev), new PVector(width, elev), false, color(255, 255, 255));
  terrain.add(startTile);

  p = new Player(new PVector(180, elev - tileWidth / 2), curSpd);
  stroke(0, 0, 0);
  
  buttons = new ArrayList<Button>();
  //Button b = new Button(new PVector(width / 2, height / 2), "whoa", 75, 50);
  //buttons.add(b); 
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
  for (LandTile tile : terrain) {
    //stroke((int) (Math.random() * 255), (int) (Math.random() * 255), (int) (Math.random() * 255));
    stroke(tile.col);
    line(tile.start.x, tile.start.y, tile.end.x, tile.end.y);
    if (tile.hasObstacle){
      fill(tile.col);
      //Obstacle obs = tile.obs;
      PVector obsApex = tile.getObsApex();
      triangle(tile.start.x, tile.start.y,
               tile.start.x + tileWidth, tile.start.y,
               //tile.start.x + tileWidth / 2, tile.start.y - (float) Math.sqrt(3) / 2 * tileWidth);
               obsApex.x, obsApex.y);
    }
  }
  // for indicating end of start tile
  line(startTile.end.x, elev, startTile.end.x, 0);
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
  for (Button button : buttons) 
    if (mousePressed & button.isMouseOnButton()) {
      if (button.getText().equals("Resume")) pause = true;
      else if (button.getText().equals("Restart")) {
        endGame();
        setup();
      }
    }
}

void draw() {
  background(0, 0, 0);
  if (! gameOver && ! pause) {
    score += 5;
    movePlayer();
  }
  displayScore();
  drawTerrain();
  drawPlayer();
  displayAllButtons();
  if (pause) pauseGame();
  else p.setSpdX(curSpd);
}


void movePlayer() {
    
  // shift terrain left to produce illusion of character movement
  for (LandTile tile : terrain) tile.shift(p.getSpdX());
  
  // continuously generate new terrain as the game runs
  if (terrain.get(0).end.x < 0) terrain.remove(0);
  LandTile lastTile = terrain.get(terrain.size() - 1);
  if (terrain.size() < 45) {
      boolean willHaveObs = Math.random() < 0.3 ? true : false;
      terrain.add(new LandTile(lastTile.end, lastTile.end.copy().set(lastTile.end.x + tileWidth, lastTile.end.y), willHaveObs, 
                color((int) (Math.random() * 255), (int) (Math.random() * 255), (int) (Math.random() * 255))));
  }
  
  // vertical player movement
  PVector pCenter = p.getCenter();
  pCenter.add(0, - p.getSpdY());

  LandTile closest = tileBelow(pCenter);
  Line surface = new Line(closest.start, closest.end);
  if (surface.distToLine(pCenter) > tileWidth / 2) {
    gravity();
    p.setRotAng(p.getRotAng() + PI / 36);
  }
  checkCollision();
}

void checkCollision() {
  
  // collision against obstacles (vertical collision)
  PVector[] corners = p.getCorners();
  for (PVector corner : corners) {
    LandTile tileUnder = tileBelow(corner);
    if (tileUnder.hasObstacle) {
      PVector apex = tileUnder.getObsApex();
      PVector endPt = corner.x > tileUnder.start.x + tileWidth / 2 ? tileUnder.end : tileUnder.start;
      Line obsSurface = new Line(apex, endPt);
      if (obsSurface.output(corner.x) - corner.y <= 0) endGame();            
    }
  }
  
  // collision against the ground (vertical collision)
  ArrayList<PVector> groundedCorners = cornersOnGround();
  int numGrounded = groundedCorners.size();
  //if (numGrounded == 1) System.out.println(numGrounded);
  if (numGrounded == 2) p.setRotAng(PI/4);
  else if (numGrounded == 1) {
    p.setRotAng(PI / 4);
    p.setSpdY(0);
  }
  
  // collision against walls (horizontal collision)
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

LandTile closestTile(PVector pt) {
  float smallestDist = Integer.MAX_VALUE;
  LandTile closestTile = null;
  for (LandTile tile : terrain) {
    float midX = (tile.start.x + tile.end.x) / 2;
    float midY = (tile.start.y + tile.end.y) / 2;
    PVector midpt = new PVector(midX, midY);
    float dist = pt.dist(midpt);
    if (dist < smallestDist) {
      smallestDist = dist;
      closestTile = tile;
    }
    else break;
  }
  return closestTile;
}

ArrayList<PVector> cornersOnGround() {
  ArrayList<PVector> grounded = new ArrayList<PVector>();
  for (PVector corner : p.getCorners()) {
    LandTile closTile = tileBelow(corner);
    Line surface = new Line(closTile.start, closTile.end);
    if (surface.output(corner.x) - corner.y <= 0) grounded.add(corner);
  }
  return grounded;
}

void endGame() {
  gameOver = true;
  p.setSpdX(0);
  System.out.println("bonk");
}

void pauseGame() {
  // freeze game
  p.setSpdX(0);
  
  // build pause menu
  //Button resume = new Button(;
  Button restart;
  System.out.println("paused");
}

void keyPressed() {
  if (key == ' ' && cornersOnGround().size() == 2 && ! gameOver && ! pause) p.jump();
  if (gameOver && key == 'a') {
    setup();
    gameOver = false;
  }
  if (keyCode == ESC) pause = !pause;
}
  
