static float lastElev;
static float lastXPos;

class Chunk {
  void genChunk() {
    int rand = (int) (Math.random() * 100);
    int easyChance, medChance;
    if (difficulty == EASY) {
      easyChance = 100;
      medChance = 0;
      //easyChance = 65;
      //medChance = 30;
      //hardChance = 5;                 
      /** variable hardChance is not used but is kept
          and commented out as a reference */
    }
    else if (difficulty == MEDIUM) {
      easyChance = 25;
      medChance = 65;
      //hardChance = 10;
    }
    else {
      easyChance = 10;
      medChance = 40;
      //hardChance = 50;
    }
    
    if (rand <= easyChance) {
      genEasyChunk();
    }
    else if (rand <= easyChance + medChance) {
      genMedChunk();
    }
    else {
      genHardChunk();
    }
  }
  
  void genEasyChunk() {
    //int randChunk = (int) (Math.random() * 4);
    int randChunk = 0;
    switch(randChunk) {
      case 0:
        //PVector start = new PVector(lastXPos, lastElev);
        //PVector end = start.copy().add(tileWidth, 0);
        //terrain.add(new LandTile(start, end, false, 1, false));
        genSafezone();

        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
    }
  }
  
  void genMedChunk() {
  }
  
  void genHardChunk() {
  }
  
  void genSafezone() {
    System.out.println("bruh");
    int toAdd = 3;
    switch(difficulty) {
      case EASY:
        toAdd += (int) (Math.random() * 10);
        break;
      case MEDIUM:
        toAdd += (int) (Math.random() * 7);
        break;
      case DIFFICULT:
        toAdd += (int) (Math.random() * 5);
        break;
    }
    LandTile lastTile = terrain.get(terrain.size() - 1);
    for (int numTiles = 0; numTiles < toAdd; numTiles++) {
      PVector start = lastTile.end.copy().add((numTiles * tileWidth), 0);
      PVector end = start.copy().add(tileWidth, 0);
      terrain.add(new LandTile(start, end, false, 0, false));
    }
  }
}
