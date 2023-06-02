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
    int randChunk = (int) (Math.random() * 8);
    randChunk = 6;
    LandTile lastTile = terrain.get(terrain.size() - 1);
    PVector start, end;
    PVector lastTileEnd = lastTile.end.copy();
    //LandTile lastTile = terrain.get;
    switch(randChunk) {
      case 0: // blank terrain
        break;
      case 1: // 1 spike
        genSpikes(1, 1, false, lastTile.end.copy());
        break;
      case 2: // 2 spikes
        genSpikes(2, 1, false, lastTile.end.copy());
        break;
      case 3: // 3 spikes
        genSpikes(3, 1, false, lastTile.end.copy());
        break;
      case 4: // jumpPad + 4 spikes
        start = terrain.get(terrain.size() - 1).end.copy();
        end = start.copy().add(tileWidth, 0);
        terrain.add(new LandTile(start, end, true, 0, false));
        lastTile = terrain.get(terrain.size() - 1);
        genSpikes(4, 1, false, lastTile.end.copy());
        break;
      case 5: // 3 spikes + platform over last spike
        genSpikes(2, 1, false, lastTile.end.copy());
        start = terrain.get(terrain.size() - 1).end.copy();
        end = start.copy().add(tileWidth, 0);
        PVector midairStart = start.copy().add(0, -sqrt(3) / 2 * tileWidth);
        terrain.add(new LandTile(midairStart, midairStart.copy().add(tileWidth, 0), false, 0, true));
        terrain.add(new LandTile(start, end, false, 1, false));
        break;
      case 6: // 5 spikes + platforms over 2nd + 3rd spikes ** needs fixing
        genSpikes(5, 1, false, lastTileEnd);
        PVector platStart = lastTile.end.copy().add(tileWidth, - tileWidth);
        genSafezone(2, platStart, true);
        genSafezone(4, lastTileEnd, false);
        break;
      case 7: // 4 midair spikes
        genSpikes(4, 1, true, lastTileEnd.copy().add(0, -tileWidth));
        genSafezone(4, lastTileEnd, false);
        
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
    PVector lastTileEnd = terrain.get(terrain.size() - 1).end.copy();
    genSafezone(toAdd, lastTileEnd, lastTileEnd.y != baseElev);
  }
  
  void genSafezone(int safes, PVector safeStart, boolean isMidair) {
    for (int numTiles = 0; numTiles < safes; numTiles++) {
      PVector start = safeStart.copy().add((numTiles * tileWidth), 0);
      PVector end = start.copy().add(tileWidth, 0);
      terrain.add(new LandTile(start, end, false, 0, isMidair));
    }
  }
  
  void genSpikes(int spikes, int spikeOrient, boolean isMidAir, PVector spikeStart) {
    //LandTile lastTile = terrain.get(terrain.size() - 1);
    for (int numTiles = 0; numTiles < spikes; numTiles++) {
      PVector start = spikeStart.copy().add(numTiles * tileWidth, 0); 
      PVector end = start.copy().add(tileWidth, 0);
      terrain.add(new LandTile(start, end, false, spikeOrient, isMidAir));
    }
  }
}
