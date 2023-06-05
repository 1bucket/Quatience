
class Chunk {
  void genChunk() {
    int rand = (int) (Math.random() * 100);
    int easyChance, medChance;
    //difficulty = DIFFICULT;
    if (difficulty == EASY) {
      // test probabilities
      easyChance = 100;
      medChance = 0;
      easyChance = 0;
      medChance = 0;
      
      // real chances
      //easyChance = 80;
      //medChance = 20;
      //hardChance = 0;
      /** variable hardChance is not used but is kept
       and commented out as a reference */
    } else if (difficulty == MEDIUM) {
      easyChance = 25;
      medChance = 65;
      //hardChance = 10;
    } else {
      easyChance = 5;
      medChance = 40;
      //hardChance = 55;
    }
  
    if (rand < easyChance) {
      genEasyChunk();

    } else if (rand < easyChance + medChance) {
      genMedChunk();
    } else {
      genHardChunk();
    }
    genSafezone();
  }

  void genEasyChunk() {
    int randChunk = (int) (Math.random() * 12);
    //randChunk = 5;
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
        //walls.add(new Wall(hillStart, tileWidth, true));
        genSafezone(4, hillStart.copy().add(0, -tileWidth), false);
        PVector nextHillStart = hillStart.copy().add(4 * tileWidth, -tileWidth);
        //walls.add(new Wall(nextHillStart, tileWidth, true));
        genSafezone(4, nextHillStart.copy().add(0, -tileWidth), false);
        PVector spikeStart = nextHillStart.copy().add(4 * tileWidth, tileWidth);
        genSpikes(3, 1, false, spikeStart);
        PVector cliffStart = spikeStart.copy().add(3 * tileWidth, 0);
        //walls.add(new Wall(cliffStart, 2 * tileWidth, true));
        genSafezone(2, cliffStart.copy().add(0, -2 * tileWidth), false);
        genSafezone(2, cliffStart.copy(), false);
        genSafezone(1, hillStart.copy().add(13 * tileWidth, 0), false);
        break;
      case 9: // jumpPad + 2 high wall
        PVector foot = lastTileEnd.copy().add(tileWidth, 0);
        terrain.add(new LandTile(lastTileEnd.copy(), foot.copy(), true, 0, false));
        walls.add(new Wall(foot.copy(), 2 * tileWidth));
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
    int randChunk = (int) (Math.random() * 11);
    //randChunk = 10;
    LandTile lastTile = terrain.get(terrain.size() - 1);
    PVector start, end;
    PVector lastTileEnd = lastTile.end.copy();
    // lxh, l = length, h = height
    switch(randChunk) {
      case 0: // 1 high spike
        genSpikes(1, 1, false, lastTileEnd.copy().add(0, -1.25 * tileWidth));
        genSafezone(1, lastTileEnd.copy(), false);
        break;
      case 1: // 11 hanging spikes (at 5 high) + 3 jumpPads
        genSpikes(15, 2, true, lastTileEnd.copy().add(0, -5 * tileWidth));
        genSafezone(1, lastTileEnd.copy(), false);
        for (int padNum = 0; padNum < 3; padNum++) {
          genPlat(1, lastTileEnd.copy().add((1 + padNum * 6) * tileWidth, 0), true, 0, false);
        }
        for (int num = 0; num < 3; num++) {
          genSafezone(5, lastTileEnd.copy().add((2 + num * 6) * tileWidth, 0), false);
        }
        break;
      case 2: // jumpOrb + 2x4 wall
        jumpOrbs.add(new JumpOrb(lastTileEnd.copy().add(tileWidth, -2.75 * tileWidth)));
        genSafezone(2, lastTileEnd.copy().add(3 * tileWidth, -4 * tileWidth), false);
        walls.add(new Wall(lastTileEnd.copy().add(3 * tileWidth, 0), 4 * tileWidth));
        genSafezone(5, lastTileEnd.copy(), false);
        break;
      case 3: // 11 spikes + 3 orbs
        genSafezone(4, lastTileEnd.copy().add(0, -tileWidth), false);
        genSpikes(20, 1, false, lastTileEnd.copy().add(4 * tileWidth, 0));
        genSafezone(4, lastTileEnd.copy().add(24 * tileWidth, -tileWidth), false);
        genSafezone(1, lastTileEnd.copy().add(25 * tileWidth, 0), false);
        jumpOrbs.add(new JumpOrb(lastTileEnd.copy().add(7 * tileWidth, -2.5 * tileWidth)));
        jumpOrbs.add(new JumpOrb(lastTileEnd.copy().add(12 * tileWidth, -4 * tileWidth)));
        jumpOrbs.add(new JumpOrb(lastTileEnd.copy().add(18 * tileWidth, -4 * tileWidth)));
        break;
      case 4: // 4 double spikes
        for (int numPairs = 0; numPairs < 4; numPairs++) {
          genSpikes(2, 1, false, lastTileEnd.copy().add(numPairs * 6 * tileWidth, 0));
        }
        for (int numSafes = 0; numSafes < 4; numSafes++) {
          genSafezone(4, lastTileEnd.copy().add((2 + numSafes * 6) * tileWidth, 0), false);
        }
        break;
      case 5: // 3 orb staircase
        for (int orbs = 0; orbs < 3; orbs++) {
          jumpOrbs.add(new JumpOrb(lastTileEnd.copy().add(tileWidth / 2 + orbs * 3.5 * tileWidth, (-2 + -3 * orbs) * tileWidth)));
        }
        genSpikes(10, 1, false, lastTileEnd.copy());
        walls.add(new Wall(lastTileEnd.copy().add(10 * tileWidth, 0), 9 * tileWidth));
        genSafezone(4, lastTileEnd.copy().add(10 * tileWidth, -9 * tileWidth), false);
        genSafezone(4, lastTileEnd.copy().add(10 * tileWidth, 0), false);
        break;
      case 6: // varying-elev platforms over 40 spikes
        genSafezone(4, lastTileEnd.copy().add(0, -tileWidth), false);
        genSafezone(3, lastTileEnd.copy().add(7 * tileWidth, -1.5  *tileWidth), true);
        genSafezone(3, lastTileEnd.copy().add(14 * tileWidth, -2 * tileWidth), true);
        genSafezone(3, lastTileEnd.copy().add(21 * tileWidth, -3 * tileWidth), true);
        genSafezone(3, lastTileEnd.copy().add(28 * tileWidth, -tileWidth), true);
        genSpikes(30, 1, false, lastTileEnd.copy().add(4 * tileWidth, 0));
        break;
      case 7: // case 6 w/ bait
        genSafezone(4, lastTileEnd.copy().add(0, -tileWidth), false);
        genSafezone(3, lastTileEnd.copy().add(7 * tileWidth, -1.5  *tileWidth), true);
        genSafezone(3, lastTileEnd.copy().add(14 * tileWidth, -2 * tileWidth), true);
        genSafezone(3, lastTileEnd.copy().add(21 * tileWidth, -3 * tileWidth), true);
        genSafezone(3, lastTileEnd.copy().add(29 * tileWidth, -4 * tileWidth), true);
        genSpikes(1, 1, true, lastTileEnd.copy().add(28 * tileWidth, -4 * tileWidth));
        genSafezone(5, lastTileEnd.copy().add(26 * tileWidth, -tileWidth), true);
        genSpikes(25, 1, false, lastTileEnd.copy().add(4 * tileWidth, 0));
        break;
      case 8: // jumpOrb bait
        genPlat(1, lastTileEnd.copy(), true, 0, false);
        genSpikes(3, 2, true, lastTileEnd.copy().add(12 * tileWidth, -6 * tileWidth));
        genSpikes(1, 1, false, lastTileEnd.copy().add(2 * tileWidth, -3 * tileWidth));
        walls.add(new Wall(lastTileEnd.copy().add(2 * tileWidth, 0), 3 * tileWidth));
        genSafezone(2, lastTileEnd.copy().add(tileWidth, 0), false);
        genSpikes(5, 1, false, lastTileEnd.copy().add(3 * tileWidth, 0));
        jumpOrbs.add(new JumpOrb(lastTileEnd.copy().add(5.5 * tileWidth, -3.5 * tileWidth)));
        jumpOrbs.add(new JumpOrb(lastTileEnd.copy().add(10.5 * tileWidth, -3.5 * tileWidth)));
        break;
      case 9: // jumpOrb staircase bait
        for (int orbs = 0; orbs < 3; orbs++) {
          jumpOrbs.add(new JumpOrb(lastTileEnd.copy().add(tileWidth / 2 + orbs * 3.5 * tileWidth, (-2 + -3 * orbs) * tileWidth)));
        }
        genSpikes(3, 1, true, lastTileEnd.copy().add(14.5 * tileWidth, - tileWidth));
        genSpikes(7, 1, false, lastTileEnd.copy());
        genSafezone(10, lastTileEnd.copy().add(7 * tileWidth, 0), false);
        break;
      case 10: // jumpPad + downward staircase bait
        genPlat(1, lastTileEnd.copy(), true, 0, false);
        genSafezone(1, lastTileEnd.copy().add(3 * tileWidth, -4 * tileWidth), true);
        genPlat(1, lastTileEnd.copy().add(4 * tileWidth, -4 * tileWidth), true, 0, true);
        genSafezone(1, lastTileEnd.copy().add(5 * tileWidth, -4 * tileWidth), true);
        genSafezone(3, lastTileEnd.copy().add(10 * tileWidth, -8 * tileWidth), true);
        genSafezone(3, lastTileEnd.copy().add(15 * tileWidth, -7 * tileWidth), true);
        genSafezone(3, lastTileEnd.copy().add(20 * tileWidth, -6 * tileWidth), true);
        genSafezone(3, lastTileEnd.copy().add(25 * tileWidth, -5 * tileWidth), true);
        genSafezone(3, lastTileEnd.copy().add(30 * tileWidth, -4 * tileWidth), true);
        genSpikes(1, 1, true, lastTileEnd.copy().add(35 * tileWidth, -3 * tileWidth));
        genSafezone(2, lastTileEnd.copy().add(36 * tileWidth, -3 * tileWidth), true);
        genSpikes(37, 1, false, lastTileEnd.copy().add(tileWidth, 0));
        break;
    }
  }

  void genHardChunk() {
    int randChunk = (int) (Math.random() * 3);
    randChunk = 5;
    LandTile lastTile = terrain.get(terrain.size() - 1);
    PVector start, end;
    PVector lastTileEnd = lastTile.end.copy();
    // lxh, l = length, h = height
    switch(randChunk) {
      case 0: // 1 high spike + 4.75 high hanging spike
        genSpikes(1, 1, false, lastTileEnd.copy().add(0, -1.25 * tileWidth));
        genSpikes(1, 2, true, lastTileEnd.copy().add(0, -4.75 * tileWidth));
        genSafezone(1, lastTileEnd.copy(), false);
        break;
      case 1: // 3 high spikes
        for (int numSpikes = 0; numSpikes < 3; numSpikes++) {
          genSpikes(1, 1, false, lastTileEnd.copy().add(7 * numSpikes * tileWidth, -1.25 * tileWidth));
          genSpikes(1, 2, true, lastTileEnd.copy().add(7 * numSpikes * tileWidth, -4.75 * tileWidth));
          genSafezone(7, lastTileEnd.copy().add(7 * numSpikes * tileWidth, 0), false);          
        }
        break;
      case 2: // tunnel w/ 4 1x3 plat
        genSpikes(28, 1, true, lastTileEnd.copy().add(0, -4 * tileWidth));
        for (int numRises = 0; numRises < 4; numRises++) {
          genSafezone(1, lastTileEnd.copy().add(9 * numRises * tileWidth, -2.5 * tileWidth), false);
          genSafezone(9, lastTileEnd.copy().add(9 * numRises * tileWidth, 0), false);
        }
        break;
      case 3: // 1, 2 plats over 30 spikes
        for (int numPlats = 0; numPlats < 5; numPlats++) {
          genSafezone(1, lastTileEnd.copy().add((1 + 8 * numPlats) * tileWidth, -2 * tileWidth), true);
          genSafezone(3, lastTileEnd.copy().add((3 + 8 * numPlats) * tileWidth, -tileWidth), true);
        }
        genSpikes(39, 1, false, lastTileEnd.copy());
        break;
      case 4: // jumpPad baits
        for (int num = 0; num < 9; num++) {
          
          genSafezone(5, lastTileEnd.copy().add((-1 + 16 * num) * tileWidth, 0), false);
          genSafezone(5, lastTileEnd.copy().add((-1 + 16 * num) * tileWidth, -0.5 * tileWidth), false);
          walls.add(new Wall(lastTileEnd.copy().add(16 * num * tileWidth, 0), 0.5 * tileWidth));
          
          boolean hasJumpPad = num > 1 ? (int) (Math.random() * 3) > 0 : true;
          genSpikes(3, 1, false, lastTileEnd.copy().add((4 + 16 * num) * tileWidth, 0));
          genSafezone(4, lastTileEnd.copy().add((7 + 16 * num) * tileWidth, -0.5 * tileWidth), false);
          genPlat(1, lastTileEnd.copy().add((11 + 16 * num) * tileWidth, -0.5 * tileWidth), hasJumpPad, 0, false);
          genSafezone(4, lastTileEnd.copy().add((7 + 16 * num) * tileWidth, 0), false);
          
          genSpikes(1, 1, false, lastTileEnd.copy().add((13 + 16 * num) * tileWidth, -0.5 * tileWidth));
          genSafezone(5, lastTileEnd.copy().add((12 + 16 * num) * tileWidth, 0), false);
          
        }
        break;
      case 5: // multiple paths
        genSafezone(5, lastTileEnd.copy().add(0, -tileWidth), true);
        genSafezone(50, lastTileEnd.copy(), true);
        break;
        
      
        
        
    }
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
    genSafezone(toAdd, lastTileEnd, false);
  }

  void genSafezone(int safes, PVector safeStart, boolean isMidair) {
    //for (int numTiles = 0; numTiles < safes; numTiles++) {
    //  PVector start = safeStart.copy().add((numTiles * tileWidth), 0);
    //  PVector end = start.copy().add(tileWidth, 0);
    //  terrain.add(new LandTile(start, end, false, 0, isMidair));
    //}
    genPlat(safes, safeStart, false, 0, isMidair);
  }
  
  void genPlat(int numTiles, PVector start, boolean willHaveJumpPad, int spikeOrient, boolean isMidair) {
    if (! isMidair && terrain.get(terrain.size() - 1).start.y != start.y && start.y != baseElev) {
      walls.add(new Wall(new PVector(start.x, baseElev), abs(start.y - baseElev))); 
    }
    for (int tile = 0; tile < numTiles; tile++) {
      PVector tileStart = start.copy().add((tile * tileWidth), 0);
      PVector end = tileStart.copy().add(tileWidth, 0);
      terrain.add(new LandTile(tileStart, end, willHaveJumpPad, spikeOrient, isMidair));
    }
  }

  void genSpikes(int spikes, int spikeOrient, boolean isMidair, PVector spikeStart) {
    //LandTile lastTile = terrain.get(terrain.size() - 1);
    genPlat(spikes, spikeStart, false, spikeOrient, isMidair );
  }
}
