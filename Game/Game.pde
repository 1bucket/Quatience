boolean pause;
int score = 0;
int elev;

float rotation;
Player p;
ArrayList<LandTile> terrain;
ArrayList<Obstacle> obstacles;

int c;
Player player; 

void setup() {
  size(1200, 600);
  tileWidth = width / 40;
  elev = height * 2 / 3;
  pause = false;
  rotation = 0;
  
  
  obsH = (float) (Math.sqrt(3) * tileWidth / 2);
  obsW = tileWidth;
  
  terrain = new ArrayList<LandTile>();
  PVector start = new PVector(0, elev);
  PVector end = start.copy().set(start.x + tileWidth, elev);
  while (end.x <= width) {
    terrain.add(new LandTile(start, end, false));
    start = new PVector(end.x, elev);
    end = start.copy().set(start.x + tileWidth, elev);
  }
  //for (LandTile tile : terrain) {
  //  System.out.println(tile);
  //}
  drawTerrain();
  
  float leftSide = terrain.get(4).start.x;
  //float rightSide = leftSide + tileWidth;
  p = new Player(new PVector(leftSide * 1.5, elev - tileWidth / 2));
  drawPlayer();
  stroke(0, 0, 0);
}

void drawPlayer() {
  PVector[] corners = p.getCorners();
  for (int index = 0; index < corners.length; index++) {
    PVector corner = corners[index];
    LandTile underTile = tileBelow(corner);
    Line surface = new Line (underTile.start, underTile.end);
    corners[index].set(corners[index].x, constrain(corner.y, 0, surface.output(corner.x)));
  }
  
  fill(50, 150, 50);
  quad(corners[0].x, corners[0].y, corners[1].x, corners[1].y,
       corners[2].x, corners[2].y, corners[3].x, corners[3].y);
}


void drawTerrain() {
  for (LandTile tile : terrain) {
    stroke((int) (Math.random() * 255), (int) (Math.random() * 255), (int) (Math.random() * 255));
    //what += 30;
    line(tile.start.x, tile.start.y, tile.end.x, tile.end.y);
    if (tile.hasObstacle){
      fill(0, 0, 0);
      Obstacle obs = tile.obs;
      triangle(obs.pos.x - obsW / 2,
               obs.pos.y,
               obs.pos.x + obsW / 2,
               obs.pos.y,
               obs.pos.x,
               obs.pos.y - obsH);
    }
  }
  stroke(200, 150, 200);
}

void draw() {
  background(255, 222, 148);
  drawTerrain();
  drawPlayer();
  movePlayer();
}


void movePlayer() {
    
    // shift terrain left to produce illusion of character movement
    for (LandTile tile : terrain) {
      tile.shift(100 - p.getSpdX());
    }
    
    // continuously generate new terrain as the game runs
    if (terrain.get(0).end.x < 0) terrain.remove(0);
    LandTile lastTile = terrain.get(terrain.size() - 1);
    if (terrain.size() < 45) 
      terrain.add(new LandTile(lastTile.end, lastTile.end.copy().set(lastTile.end.x + tileWidth, lastTile.end.y), false));
    
    
  // ensure player does not go below ground
  PVector pCenter = p.getCenter();
  pCenter.add(0, - p.getSpdY());

  LandTile closest = tileBelow(pCenter);
  Line surface = new Line(closest.start, closest.end);
  //System.out.println(surface.distToLine(pCenter));
  if (surface.distToLine(pCenter) > tileWidth / 2) {
    gravity();
    p.setRotAng(p.getRotAng() + PI / 36);
  }
  else p.setSpdY(0);
  
  // jumping and falling
  ArrayList<PVector> groundedCorners = cornersOnGround();
  int numGrounded = groundedCorners.size();
  //if (numGrounded == 1) System.out.println(numGrounded);
  if (numGrounded == 2) p.setRotAng(PI/4);
  else if (numGrounded == 1) {
    p.setRotAng(PI / 4);
    p.setSpdY(0);
    //System.out.println("bruh");
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
  //return closestTile;
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

void keyPressed() {
  if (key == ' ' && cornersOnGround().size() == 2) p.jump();
  //for (PVector corner : p.getCorners()) System.out.println(corner);
}
  
