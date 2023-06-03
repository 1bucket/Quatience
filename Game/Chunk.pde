
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
    } else if (difficulty == MEDIUM) {
      easyChance = 25;
      medChance = 65;
      //hardChance = 10;
    } else {
      easyChance = 10;
      medChance = 40;
      //hardChance = 50;
    }

    if (rand <= easyChance) {
      genEasyChunk();
    } else if (rand <= easyChance + medChance) {
      genMedChunk();
    } else {
      genHardChunk();
    }
    genSafezone();
  }

  void genEasyChunk() {
    int randChunk = (int) (Math.random() * 12);
    //randChunk = 11;
    LandTile lastTile = terrain.get(terrain.size() - 1);
    PVector start, end;
    PVector lastTileEnd = lastTile.end.copy();
    // lxh, l = length, h = height
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
      case 6: // 5 spikes + platforms over 2nd-4th spikes ** needs fixing
        genSpikes(5, 1, false, lastTileEnd);
        PVector platStart = lastTile.end.copy().add(tileWidth, - tileWidth);
        genSafezone(3, platStart, true);
        genSafezone(4, lastTileEnd, false);
        break;
      case 7: // 4 midair spikes
        genSpikes(4, 1, true, lastTileEnd.copy().add(0, -tileWidth));
        genSafezone(4, lastTileEnd, false);
        break;
      case 8: // hill + 3 spikes
        genSafezone(8, lastTileEnd, false);
        PVector hillStart = lastTileEnd.copy();
        walls.add(new Wall(hillStart, tileWidth, true));
        genSafezone(4, hillStart.copy().add(0, -tileWidth), false);
        PVector nextHillStart = hillStart.copy().add(4 * tileWidth, -tileWidth);
        walls.add(new Wall(nextHillStart, tileWidth, true));
        genSafezone(4, nextHillStart.copy().add(0, -tileWidth), false);
        PVector spikeStart = nextHillStart.copy().add(4 * tileWidth, tileWidth);
        genSpikes(3, 1, false, spikeStart);
        PVector cliffStart = spikeStart.copy().add(3 * tileWidth, 0);
        walls.add(new Wall(cliffStart, 2 * tileWidth, true));
        genSafezone(2, cliffStart.copy().add(0, -2 * tileWidth), false);
        genSafezone(2, cliffStart.copy(), false);
        genSafezone(1, hillStart.copy().add(13 * tileWidth, 0), false);
        break;
      case 9: // jumpPad + 2 high wall
        PVector foot = lastTileEnd.copy().add(tileWidth, 0);
        terrain.add(new LandTile(lastTileEnd.copy(), foot.copy(), true, 0, false));
        walls.add(new Wall(foot.copy(), 2 * tileWidth, true));
        genSafezone(1, foot.copy().add(0, -2 * tileWidth), false);
        genSafezone(1, foot.copy(), false);
        break;
      case 10: // jumpPad + 1x2 plat + 2x1 plat
        terrain.add(new LandTile(lastTileEnd.copy(), lastTileEnd.copy().add(tileWidth, 0), true, 0, false));
        genSafezone(4, lastTileEnd.copy().add(4 * tileWidth, -2 * tileWidth), true);
        genSpikes(1, 1, true, lastTileEnd.copy().add(8 * tileWidth, -1.5 * tileWidth));
        genSafezone(8, lastTileEnd.copy().add(tileWidth, 0), false);
        break;
      case 11: // 4x1 hanging spikes
        genSpikes(4, 2, true, lastTileEnd.copy().add(0, -tileWidth));
        genSafezone(4, lastTileEnd.copy(), false);
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
