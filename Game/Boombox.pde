
import processing.sound.*;

class Boombox {
  private SoundFile background;
  private ArrayList<SoundFile> fx;
  private ArrayList<String> playlist;
  private ArrayList<String> played;
  
  public Boombox() {
    fx = new ArrayList<SoundFile>();
    playlist = new ArrayList<String>();
    played = new ArrayList<String>();
  }
  public void playMainMenuTrack() {
    background = new SoundFile(this, "soundtracks/menu/mixkit-deep-urban-623.mp3");
    
  }
  
  public void playGameTrack() {
  }
}
