import processing.sound.*;

boolean pause;
int difficulty;
final int EASY = 0;
final int MEDIUM = 1;
final int DIFFICULT = 2;
boolean classicMode;
int score = 0;
int baseElev;
boolean gameOver;
String splash;
String[] splashText = new String[] {
    "The game that waits for you to lose!",
    "It's like that dinosaur game but harder",
    //"Disclaimer: The music is not synced with the course",
    "Play at your own risk!",
    "If you've been playing too long, it might be time for a break",
    "I did not need to try this hard to make this game",
    "Please tell me this game is good I spent a few too many hours on it",
    "It's like that dinosaur game but without birds and with more cacti",
    "Hint: The spikes are not friendly, and neither are walls",
    "If it looks like a trap, it probably is",
    "There is a fine line between ambition and greed",
    "Watch out!",
    "Hello Brian",
    "Splash text not inspired by Minecraft I swear"
};
boolean isInMainMenu;
String startGame;
String quitGame;
ArrayList<Button> buttons;
int surviveTime;
boolean isChoosingDiff;
boolean canPushButton;
float bTimer;

Player p;
int doubleJumps;
boolean canJump;
ArrayList<PVector> trail;
color pCol;
color themeColor;
int lineWeight;
int exploSize;
int opacity;

Chunk gen;
ArrayList<LandTile> terrain;
ArrayList<Wall> walls;
ArrayList<JumpOrb> jumpOrbs;
ArrayList<PVector> rectPoints;
ArrayList<Coin> coins;
ArrayList<Powerup> powerups;
int invTimer;
int doubleJTimer;
int rWidth;
LandTile startTile;
LandTile testTile;

SoundFile menuTrack;
SoundFile background;
SoundFile[] fx;
final int BUTTON = 0;
final int START = 1;
final int COIN = 2;
final int POWERUP = 3;
final int DEATH = 4;
ArrayList<SoundFile> playlist;
ArrayList<SoundFile> played;

void setup() {
  fullScreen();
  themeColor = color(0, 15, 221);
  background(red(themeColor), green(themeColor) + 70, blue(themeColor));
  
  loadFX();
  loadPlaylist();
  menuTrack = new SoundFile(this, "soundtracks/menu/mixkit-deep-urban-623.mp3");
  newGame(true, true);
}

void newGame(boolean withMainMenu, boolean willBeClassic) {
  
  loadFX();
  if (withMainMenu) {
    menuTrack.loop();
    menuTrack.amp(0.5);
  }
  else {
    fx[START].play();
    fx[START].amp(0.5);
    if (menuTrack != null) menuTrack.stop();
    if (background != null) background.stop();
    resetPlaylist();
    beginTrack();
  }
  
  gameOver = false;
  pause = false;
  score = 0;
  pause = false;
  isInMainMenu = withMainMenu;
  canPushButton = true;
  isChoosingDiff = false;
  frameCount = 0;
  surviveTime = 0;
  
  classicMode = willBeClassic;
  if (classicMode && ! withMainMenu) surviveTime = 0;
  
  lineWeight = 1;
  rWidth = 120;
  
  tileWidth = width / 40;
  baseElev = height * 3 / 4;
  orbRadius = (int) (2.0 / 3.0 * tileWidth);
  
  coinRadius = tileWidth;
  coins = new ArrayList<Coin>();
  
  powerupRadius = (int) (0.5 * tileWidth);
  powerups = new ArrayList<Powerup>();
  invTimer = 0;
  doubleJTimer = 0;
  trail = new ArrayList<PVector>();
  
  pCol = color(0, 255, 246);
  canJump = true;
  doubleJumps = 0;
  
  // for animation
  opacity = 256;
  exploSize = (int) (tileWidth * sqrt(2));
  
  buttons = new ArrayList<Button>();
  walls = new ArrayList<Wall>();
  
  gen = new Chunk();
  terrain = new ArrayList<LandTile>();
  startTile = new LandTile(new PVector (0, baseElev), new PVector(width, baseElev), false, 0, false);
  terrain.add(startTile);
  walls = new ArrayList<Wall>();
  rectPoints = new ArrayList<PVector>();
    
  jumpOrbs = new ArrayList<JumpOrb>();
  
  p = new Player(new PVector(180, baseElev - tileWidth / 2), width / 200);
  
  if (withMainMenu) newMainMenu();
  
}

void loadFX() {
  fx = new SoundFile[5];
  fx[BUTTON] = new SoundFile(this, "sounds/mixkit-cool-interface-click-tone-2568.wav");
  fx[START] = new SoundFile(this, "sounds/mixkit-retro-game-notification-212.wav");
  fx[COIN] = new SoundFile(this, "sounds/mixkit-arcade-game-jump-coin-216.wav");
  fx[POWERUP] = new SoundFile(this, "sounds/mixkit-winning-a-coin-video-game-2069.wav");
  fx[DEATH] = new SoundFile(this, "sounds/mixkit-arcade-retro-game-over-213.wav");
}

void loadPlaylist() {
  playlist = new ArrayList<SoundFile>();
  playlist.add(new SoundFile(this, "soundtracks/ingame/mixkit-alter-ego-481.mp3"));
  playlist.add(new SoundFile(this, "soundtracks/ingame/mixkit-anthem-01-567.mp3"));
  playlist.add(new SoundFile(this, "soundtracks/ingame/mixkit-praise-the-lord-262.mp3"));
  playlist.add(new SoundFile(this, "soundtracks/ingame/mixkit-rising-forest-471.mp3"));
  playlist.add(new SoundFile(this, "soundtracks/ingame/mixkit-swing-is-the-answer-526.mp3"));
  
  played = new ArrayList<SoundFile>();
}
void resetPlaylist() {
  while (played.size() > 0) {
    playlist.add(played.remove(0));
  }
}

void beginTrack() {
  background = playlist.remove((int) random(0, playlist.size()));
  background.play();
  background.amp(0.5);
  played.add(background);
}

void shufflePlay() {
  if (! background.isPlaying()) {
    if (playlist.size() == 0) resetPlaylist();
    beginTrack();
  }
}

void drawOrbs() {
  noStroke();
  fill(red(pCol) + 42, green(pCol) + 40, blue(pCol) + 34);
  for (JumpOrb orb : jumpOrbs) {
    PVector pos = orb.getPos();
    circle(pos.x, pos.y, orbRadius * 2);
  }
}

void drawPlayer() {
  
  fill(0);
  
  if (gameOver) {
    // death animation
    noStroke();
    fill(pCol, opacity -= 20);
    circle(p.getCenter().x, p.getCenter().y, exploSize += 5);
  }
  else {
    if (p.doubleJump) {
      trail.add(p.getCenter().copy());
    }
    // trail, if applicable
    fill(106, 255, 33);
    noStroke();
    for (int index = 0; index < trail.size(); index++) {
      PVector trailPt = trail.get(index); 
      if (trailPt.x < 2 * tileWidth) {
        trail.remove(index--);
      }
      else {
        circle(trailPt.x, trailPt.y, tileWidth);
      }
    }
    fill(0);
    stroke(p.doubleJump ? color(106, 255, 33) : pCol);
    strokeWeight(1.5);
    if (p.isInvincible && frameCount % 30 < 15) {
      fill(116, 0, 0);
      stroke(170, 0, 0);
    }
    PVector[] corners = p.getCorners();
    quad(corners[0].x, corners[0].y, corners[1].x, corners[1].y,
         corners[2].x, corners[2].y, corners[3].x, corners[3].y);
  }
}

void drawTerrain() {
  // modified loop to incorporate changes in elevation
  strokeWeight(lineWeight);
  for (LandTile tile : terrain) {
    stroke(themeColor);
    
    fill(red(themeColor) - 70, green(themeColor), blue(themeColor) - 90);
    if (tile.isMidair) {
      line(tile.start.x, tile.start.y + 10, tile.end.x, tile.end.y + 10);
      rect(tile.start.x, tile.start.y, tile.end.x - tile.start.x, 10);
    }
    else {
      noStroke();
      
      rect(constrain(tile.start.x, 0, tile.end.x), baseElev, tile.end.x, height);
      if (tile.start.y != baseElev) {
        stroke(red(themeColor) - 80, green(themeColor), blue(themeColor) - 120);
        strokeWeight(2);
        rect(tile.start.x, tile.start.y, tileWidth, abs(baseElev - tile.start.y));
      }
      stroke(themeColor);
    }

    int obsStatus = tile.getObsStatus(); 
    if (obsStatus != 0) {
      fill(0);
      stroke(themeColor);
      strokeWeight(1);
      
      PVector obsApex = tile.getObsApex();
      if (obsStatus == 1){
        triangle(tile.start.x, tile.start.y,
                 tile.start.x + tileWidth, tile.start.y,
                 obsApex.x, obsApex.y);
      }
      else if (obsStatus == 2) {
        triangle(tile.start.x, tile.start.y + 10,
                 tile.start.x + tileWidth, tile.start.y + 10,
                 obsApex.x, obsApex.y);
      }
    }
    if (tile.hasJumpPad) {
      fill(pCol);
      rect(tile.start.x, tile.start.y - 5, Math.abs(tile.start.x - tile.end.x), 5);
    }
  }
  stroke(200, 150, 200);
}

void displayScore() {
  fill(255, 255, 255);
  textSize(40);
  textAlign(CENTER);
  text(score, width / 2, 40);
}

void displayBuffs() {
  ArrayList<String> buffs = new ArrayList<String>();
  if (invTimer > 0) {
    buffs.add("Invincibility: " + invTimer);
  }
  if (doubleJTimer > 0) {
    buffs.add("Double Jump: " + doubleJTimer);
  }
  textSize(50);
  textAlign(LEFT);
  fill(255);
  for (int index = 0; index < buffs.size(); index++) {
    text(buffs.get(index), 10, (index + 1) * 50);
  }
}

void displayAllButtons() {
  for (Button button : buttons) button.displayButton();
}

void runButtonTimer() {
  canPushButton = bTimer == 0;
  if (bTimer > 0 && frameCount % 30 == 0) {
    bTimer -= 0.5;
  }
}

void activateButton() {
  for (Button button : buttons)  {
    if (mousePressed & button.isMouseOnButton()) {
      fx[BUTTON].play();
      fx[BUTTON].amp(0.7);
      String bText = button.getText();
      if (bText.equals("Resume")) {
        resumeGame();
        background.play();
      }
      else if (bText.equals("Restart")) {
        newGame(false, classicMode);
      }
      else if (bText.equals("Start Game") || bText.equals("Start Suffering")) {
        isChoosingDiff = true;
        buttons = new ArrayList<Button>();
        newDiffSelect();
      }
      else if (bText.equals("Quit")) {
        exit();
      }
      else if (bText.equals("Classic")) {
        newGame(false, true);
        difficulty = EASY;
      }
      else if (bText.equals("Easy")) {
        newGame(false, false);
        difficulty = EASY;
      }
      else if (bText.equals("Medium")) {
        newGame(false, false);
        difficulty = MEDIUM;
      }
      else if (bText.equals("Difficult")) {
        newGame(false, false);
        difficulty = DIFFICULT;
      }
      else if (bText.equals("Main Menu")) {
        newGame(true, false);
      }
      bTimer = 0.5;
    }
  }
}

void drawUnderground() {
  fill(themeColor, 100);
  noStroke();
  for (PVector rectCorn : rectPoints) {
    rect(rectCorn.x, rectCorn.y, rWidth, height);
  }
}

void drawCoins() {
  stroke(0);
  strokeWeight(2);
  fill(255, 217, 0);
  for (Coin coin : coins) {
    PVector pos = coin.getPos();
    ellipse(pos.x, pos.y, 2 * coinRadius * sin(PI / 45 * frameCount), 2 * coinRadius);
  }
}

void newMainMenu() {
  splash = splashText[(int) (Math.random() * splashText.length)];
  startGame = Math.random() > 0.2 ? "Start Game" : "Start Suffering";
  quitGame = Math.random() > 0.2 ? "Quit" : "Rage quit";
  
  PVector midpt = new PVector(width / 2, height * 0.65);
  buttons.add(new Button(midpt.copy().add(-200, 0), startGame, 225, 80));
  buttons.add(new Button(midpt.copy().add(200, 0), quitGame, 225, 80));
}

void drawTitle() {
  textSize(100);
  textAlign(CENTER);
  
  text("Geometry Dash Infinite", width / 2, height * 2 / 5);
  
  textSize(5 * abs(sin(PI / 45 * frameCount)) + 30);
  text(splash, width / 2, height * 0.5);
}

void newDiffSelect() {
  PVector midpt = new PVector(width / 2, height * 0.7);
  buttons.add(new Button(midpt.copy().add(-450, 0), "Classic", 255, 80));
  buttons.add(new Button(midpt.copy().add(-150, 0), "Easy", 255, 80));
  buttons.add(new Button(midpt.copy().add(150, 0), "Medium", 255, 80));
  buttons.add(new Button(midpt.copy().add(450, 0), "Difficult", 255, 80));
}

void loadDeathMenu() {
  int bWidth = 120;
  int bHeight = 75;
  PVector midpt = new PVector(width / 2, height * 0.85);
  Button quit = new Button(midpt.copy().add(250, 0), "Quit", bWidth, bHeight); 
  Button restart = new Button(midpt.copy().add(-250, 0), "Restart", bWidth, bHeight);
  Button mainMenu = new Button(midpt.copy(), "Main Menu", 2 * bWidth, bHeight);
  buttons.add(quit);
  buttons.add(restart);
  buttons.add(mainMenu);
}

void drawDeathMenu() {
  textAlign(CENTER);
  fill(255);
  textSize(50);
  text("Score: " + score, width / 2, height * 0.75);
}

void drawDiffSelect() {
  textSize(50);
  fill(0);
  textAlign(CENTER);
  
  text("Select gamemode", width / 2, height * 0.6);
  
  
  for (Button button : buttons) {
    if (button.isMouseOnButton()) {
      fill(83, 127, 255);
      PVector diffDescPos = new PVector(width / 2, height * 0.85);
      String bText = button.getText();
      if (bText.equals("Classic")) {
        text("Steady progression from easy to difficult", diffDescPos.x, diffDescPos.y);
      }
      else if (bText.equals("Easy")) {
        text("Should be relatively manageable", diffDescPos.x, diffDescPos.y);
      }
      else if (bText.equals("Medium")) {
        text("For those that want a bit of a challenge", diffDescPos.x, diffDescPos.y);
      }
      else if (bText.equals("Difficult")) {
        text("Please don't do this to yourself", diffDescPos.x, diffDescPos.y);
      }
    }
  }
}

void drawPowerups() {
  stroke(0);
  strokeWeight(2);
  for (Powerup powerup : powerups) {
    int powerupVar = powerup.getPowerVar();
    if (powerupVar == INVINCIBLE) {
      fill(233, 0, 0);
    }
    else if (powerupVar == DOUBLE_JUMP) {
      fill(106, 255, 33);
    }
    if (frameCount % 20 < 10) fill(255);
    PVector powerupPos = powerup.getPos();
    circle(powerupPos.x, powerupPos.y, 2 * powerupRadius);
  }
}

void draw() { 
  background(red(themeColor), green(themeColor) + 70, blue(themeColor));
  
  if (! gameOver && ! pause) {
    if (! isInMainMenu) {
      score++;
      shufflePlay();
    }
    movePlayer();
  }
  if (! isInMainMenu && ! gameOver) displayScore();
  drawTerrain();
  drawUnderground();
  drawOrbs();
  drawCoins();
  drawPlayer();
  drawPowerups();
  displayBuffs();
  runPowerupTimer();
  if (classicMode && ! pause && ! isInMainMenu && ! gameOver) {
    surviveTime++;
    updateDifficulty();
  }
  displayAllButtons();
  runButtonTimer();
  if (canPushButton) activateButton();
  
  if (isInMainMenu || isChoosingDiff) drawTitle();
  if (isChoosingDiff) drawDiffSelect();
  
  if (gameOver) {
    drawDeathMenu();
  }
}

void updateDifficulty() {
  float secondsAlive = surviveTime / 60.0;
  if (secondsAlive == 45) difficulty = MEDIUM;
  else if (secondsAlive == 120) difficulty = DIFFICULT;
}

void runPowerupTimer() {
  p.isInvincible = invTimer > 0;
  p.doubleJump = doubleJTimer > 0;
  if (frameCount % 60 == 0 && ! gameOver && ! pause) {
    if (invTimer > 0) {
      invTimer--;
    }
    if (doubleJTimer > 0) {
      doubleJTimer--;
    }
  }
}

void movePlayer() {
    
  // shift terrain left to produce illusion of character movement
  for (LandTile tile : terrain) tile.shift(p.getSpdX());
  for (Wall wall : walls) wall.shift(p.getSpdX());
  for (JumpOrb orb : jumpOrbs) orb.shift(p.getSpdX());
  for (PVector rectCorn : rectPoints) rectCorn.add(- p.getSpdX(), 0);
  for (Coin coin : coins) coin.shift(p.getSpdX());
  for (Powerup powerup : powerups) powerup.shift(p.getSpdX());
  for (PVector trailPt : trail) trailPt.add(-p.getSpdX(), 0);
  
  
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
      if (jumpOrbs.get(index).getPos().x + orbRadius < 0) {
        jumpOrbs.remove(index--);
      }
    }
  }
  
  if (rectPoints.size() > 0) {
    for (int index = 0; index < rectPoints.size(); index++) {
      if (rectPoints.get(index).x < - rWidth) {
        rectPoints.remove(index--);
      }
    }
  }
  
  if (coins.size() > 0) {
    for (int index = 0; index < coins.size(); index++) {
      if (coins.get(index).getPos().x < -coinRadius) {
        coins.remove(index--);
      }
    }
  }
  
  if (powerups.size() > 0) {
    for (int index = 0; index < powerups.size(); index++) {
      if (powerups.get(index).getPos().x < -powerupRadius) {
        powerups.remove(index--);
      }
    }
  }
  
  LandTile curTile = terrain.get(0);
  if (curTile.end.x < -5) terrain.remove(curTile);
  LandTile lastTile = terrain.get(terrain.size() - 1);
  
  // continuously generate new terrain as the game runs
  if (lastTile.end.x < width) {
    if (isInMainMenu) {
      PVector start = lastTile.end.copy();
      terrain.add(new LandTile(start, start.copy().add(width, 0), false, 0, false));
    }
    else {
      gen.genChunk();
    }
    if (Math.random() < 0.05) {
      gen.genPowerup((int) random(0, 2));
    }
  }
  
  while (rectPoints.size() <= width / (rWidth + 20) + 1) {
    if (rectPoints.size() == 0) rectPoints.add(new PVector(0, baseElev + 20));
    else rectPoints.add(rectPoints.get(rectPoints.size() - 1).copy().add(rWidth + 20, 0));
  }
  
  
  // vertical player movement
  PVector pCenter = p.getCenter();
  LandTile belowTile = tileBelow(pCenter);
  pCenter.add(0, - p.getSpdY());
  pCenter.set(pCenter.x, constrain(pCenter.y, Float.NEGATIVE_INFINITY, belowTile.start.y - tileWidth / 2));
  checkCollision();
}

void checkCollision() {
  PVector[] corners = p.getCorners();
  
  PVector pCenter = p.getCenter();
  
  // collisions against ground and obstacles
  int grounded = 0;
  for (PVector corner : corners) {
    
    // obtaining coins
    for (int index = 0; index < coins.size(); index++) {
      if (corner.dist(coins.get(index).getPos()) < coinRadius) {
        score += 500;
        coins.remove(index--);
        fx[COIN].play();
        fx[COIN].amp(0.5);
      }
    }
    
    // obtaining powerups
    for (int index = 0; index < powerups.size(); index++) {
      Powerup powerup = powerups.get(index);
      if (corner.dist(powerup.getPos()) < powerupRadius + 15) {
        int powerupVar = powerup.getPowerVar();
        if (powerupVar == INVINCIBLE) {
          invTimer = 30;
        }
        else if (powerupVar == DOUBLE_JUMP) {
          doubleJTimer = 30;
        }
        powerups.remove(index--);
        fx[POWERUP].play();
        fx[POWERUP].amp(0.5);
      }
    }
        
    
    // wall collision
    for (Wall wall : walls) {
      PVector wallPos = wall.getPos();
      if (pCenter.x < wallPos.x &&
          numInRange(corner.x, wallPos.x, wallPos.x + tileWidth) && 
          numInRange(corner.y, wall.getTopElev(), wallPos.y)) {
            if (p.isInvincible) {
              p.getCenter().add(0,-8 * tileWidth);
            }
            else {
              endGame();
            }
          }
        
    }
    
    // obstacle collision detection
    LandTile tileUnder = tileBelow(corner);
    if (tileUnder.getObsStatus() == 1) {
      PVector apex = tileUnder.getObsApex();
      PVector endPt = corner.x > tileUnder.start.x + tileWidth / 2 ? tileUnder.end : tileUnder.start;
      Line obsSurface = new Line(apex, endPt);
      if (obsSurface.output(corner.x) - corner.y <= 0 && pCenter.y < tileUnder.start.y) {
        if (p.isInvincible) {
          p.jump(MAJOR);
        }
        else {
          endGame();
        }
      }
    }
    
    // ceiliing collision detection
    LandTile tileAbove = tileAbove(corner);
    if (tileAbove != null) {
      if (tileAbove.getObsStatus() == 2) {
        PVector apex = tileAbove.getObsApex();
        PVector endPt = corner.x > tileAbove.start.x + tileWidth / 2  ? tileAbove.end.copy().add(0, 5) : tileAbove.start.copy().add(0, 5);
        Line obsSurface = new Line(apex, endPt);
        if (corner.y - obsSurface.output(corner.x) <= 0 && pCenter.y > tileAbove.start.y + 5) {
          if (p.isInvincible) {
            p.setSpdY(abs(p.getSpdY()) * -1);
          }
          else {
            endGame();
          }
        }
      }
      else if (corner.y <= tileAbove.start.y + 5 && pCenter.y > tileAbove.start.y + 5) {
        if (p.isInvincible) {
          p.setSpdY(abs(p.getSpdY()) * -1);
        }
        else {
          endGame();
        }
      }
    }
    
    
    
    // ground collision detection
    if (corner.y >= tileUnder.start.y && pCenter.y < tileUnder.start.y) {
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
    if (grounded == 2) {
      pCenter.set(pCenter.x, tileBelow(pCenter).start.y - tileWidth / 2);
      doubleJumps = 0;
    }
    canJump = true;
  }
  else {
    gravity();
    p.setRotAng(p.getRotAng() + PI / 45);
    canJump = false;
  }
}

void gravity() {
  p.setSpdY(p.getSpdY() - (1 / 30.0 * tileWidth));
}

LandTile tileBelow(PVector point) {
  PVector pCenter = p.getCenter();
  ArrayList<LandTile> cands = new ArrayList<LandTile>();
  for (LandTile tile : terrain) {
    if (point.x >= tile.start.x && point.x <= tile.end.x && pCenter.y < tile.start.y)
      cands.add(tile);
  }
  float diff = Integer.MAX_VALUE;
  LandTile closest = null;
  for (LandTile cand : cands) {
    float curDiff = abs(pCenter.y - cand.start.y);
    if (curDiff < diff) {
      diff = curDiff;
      closest = cand;
    }
  }
  return closest;

}

LandTile tileAbove(PVector point) {
  for (LandTile tile : terrain) {
    if (point.x >= tile.start.x && point.x <= tile.end.x && point.y > tile.start.y)
      return tile;
  }
  return null;
}

LandTile tileBefore(LandTile tile) {
  for (LandTile cand : terrain) {
    if (cand.end.x - tile.start.x == 0 && cand.end.y == tile.start.y) {
      return cand;
    }
  }
  return null;
}

// returns true if the player is within the vicinity of 
boolean checkOrbCollision() {
  PVector pCenter = p.getCenter();
  for (JumpOrb orb : jumpOrbs) {
    if (pCenter.dist(orb.getPos()) < orbRadius + 20) {
      return true;
    }
  }
  return false;
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
  fx[DEATH].play();
  fx[DEATH].amp(0.5);
  if (background != null) background.stop();
  gameOver = true;
  p.setSpdX(0);
  loadDeathMenu();

}

void pauseGame() {
  pause = true;  
  // build pause menu
  int bWidth = 120;
  int bHeight = 75;
  PVector midpt = new PVector(width / 2, height * .75);
  Button resume = new Button(midpt.copy().add(-250, 0), "Resume", bWidth, bHeight);
  //resume.displayButton();
  Button restart = new Button(midpt.copy().add(250, 0), "Restart", bWidth, bHeight);
  Button mainMenu = new Button(midpt.copy(), "Main Menu", 2 * bWidth, bHeight);
  buttons.add(resume);
  buttons.add(restart);
  buttons.add(mainMenu);
}

void resumeGame() {
  pause = false;
  buttons = new ArrayList<Button>();
}

void keyPressed() {
  if (key == ' ' && ! gameOver && ! pause) {
    if (checkOrbCollision()) p.jump(MINOR);
    if (canJump) {
      p.jump(NORMAL);
    }
    else if (checkOrbCollision()) p.jump(MINOR);
    else if (p.doubleJump && doubleJumps < 1) {
      p.jump(NORMAL);
      doubleJumps++;
    }
    
  }
  if (key == 'a' && ! isInMainMenu) {
    newGame(false, classicMode);
  }
  if (key == 'q' && ! isInMainMenu && ! gameOver) {
    if (pause) {
      resumeGame();
      background.play();
    }
    else {
      pauseGame();
      background.pause();
    }
  }
}
  
