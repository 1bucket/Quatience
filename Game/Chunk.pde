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
    genSafezone();
  }
  
  void genEasyChunk() {
    int randChunk = (int) (Math.random() * 7);
    //LandTile lastTile = terrain.get(terrain.size() - 1);
    PVector start, end;
    switch(randChunk) {
      case 0:
        break;
      case 1:
        genSpikes(1, 1, false);
        break;
      case 2:
        genSpikes(2, 1, false);
        break;
      case 3:
        genSpikes(3, 1, false);
        break;
      case 4:
        start = terrain.get(terrain.size() - 1).end.copy();
        end = start.copy().add(tileWidth, 0);
        terrain.add(new LandTile(start, end, true, 0, false));
        genSpikes(4, 1, false);
        break;
      case 5:
        genSpikes(2, 1, false);
        start = terrain.get(terrain.size() - 1).end.copy();
        end = start.copy().add(tileWidth, 0);
        PVector midairStart = start.copy().add(0, -sqrt(3) / 2 * tileWidth);
        terrain.add(new LandTile(midairStart, midairStart.copy().add(tileWidth, 0), false, 0, true));
        terrain.add(new LandTile(start, end, false, 1, false));
        break;
      case 6:
        genSpikes(3, 1, false);
        LandTile lastTile = terrain.get(terrain.size() - 1);
        start = lastTile.end.copy().add(- tileWidth, -sqrt(3) / 2 * tileWidth);
        end = start.copy().add(tileWidth, 0);
        for (int numTiles = 0; numTiles < 2; numTiles++) {
          terrain.add(new LandTile(start.copy().add(numTiles * tileWidth, 0), end.copy().add(numTiles * tileWidth, 0), false, 0, true));
        }
        start = lastTile.end.copy();
        terrain.add(new LandTile(start, start.copy().add(tileWidth, 0), false, 1, false));
        genSpikes(1, 1, false);
        break;
      
    }
  }
  
  void genMedChunk() {
  }
  
  void genHardChunk() {
  }
  
  void genSafezone() {
    //System.out.println("bruh");
    int toAdd = 7;
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
  
  void genSpikes(int spikes, int spikeOrient, boolean isMidAir) {
    LandTile lastTile = terrain.get(terrain.size() - 1);
    for (int numTiles = 0; numTiles < spikes; numTiles++) {
      PVector start = lastTile.end.copy().add(numTiles * tileWidth, 0); 
      PVector end = start.copy().add(tileWidth, 0);
      terrain.add(new LandTile(start, end, false, spikeOrient, isMidAir));
    }
  }
}
