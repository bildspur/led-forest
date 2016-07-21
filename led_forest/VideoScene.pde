import processing.video.*; //<>// //<>//
import java.io.FilenameFilter;

class VideoScene extends Scene
{
  String[] videoFiles;
  int activeVideoIndex = -1;

  float wspace2d = 20;
  float hspace2d = 2;
  
  float hoffset = 50;
  float woffset = 50;
  
  float width2d = 15;
  float height2d = 15;

  Movie activeVideo;

  boolean isFixtureSpaceSet = false;

  public boolean isUnique()
  {
    return true;
  }

  public String getName()
  {
    return "Video Scene ("+ videoFiles[activeVideoIndex]+")";
  }

  public void init()
  {
    videoFiles = readVideoFiles();

    if (videoFiles.length > 0)
    {
      activeVideoIndex = (activeVideoIndex + 1) % videoFiles.length;
      activeVideo = new Movie(led_forest.this, videoFiles[activeVideoIndex]);
      activeVideo.loop();

      isFixtureSpaceSet = false;
    } else
    {
      activeVideo = null;
    }
  }

  public void dispose()
  {
    if (activeVideo != null)
      activeVideo.stop();
  }

  public void update()
  {
    if (frameCount <= 1)
      return;

    if (activeVideo == null)
      return;

    if (!isFixtureSpaceSet)
      setFixtureSpace(tubes.size(), tubes.get(0).leds.size(), activeVideo.width, activeVideo.height);

    /*
    cam.beginHUD();
     tint(255, 255);
     image(activeVideo, 0, 0);
     cam.endHUD();
     */

    for (int j = 0; j < tubes.size(); j++)
    {
      for (int i = 0; i < tubes.get(j).leds.size(); i++)
      {
        setColorForLED(activeVideo, j, i);
      }
    }
  }

  void setFixtureSpace(int tubeCount, int ledCount, float w, float h)
  {
      wspace2d = (w - (tubeCount * width2d + woffset)) / tubeCount;
      hspace2d = (h - (ledCount * height2d + hoffset)) / ledCount;
      
      isFixtureSpaceSet = true;
  }

  void setColorForLED(PImage videoFrame, int tubeIndex, int ledIndex)
  {
    // set window
    int x = (int)(ledIndex * (wspace2d + width2d) + woffset);
    int y = (int)(tubeIndex * (hspace2d + height2d) + hoffset);
    int w = (int)(x + width2d);
    int h = (int)(y + height2d);

    color c = getAverage(videoFrame, x, y, w, h);
    tubes.get(tubeIndex).leds.get(ledIndex).c.fade(c, 0.8);
  }

  color getAverage(PImage img, int x, int y, int w, int h)
  {
    // hsb mode
    int hue = 0;
    int sat = 0;
    int bright = 0;

    int count = (w-x) * (h-y);

    for (int u = x; u < w; u++)
    {
      for (int v = y; v < h; v++)
      {
        color c = img.get(u, v);
        hue += hue(c);
        sat += saturation(c);
        bright += brightness(c);
      }
    }

    return color(hue / count, sat / count, bright / count);
  }

  String[] readVideoFiles()
  {
    java.io.File folder = new java.io.File(sketchPath("data"));
    return folder.list(new FilenameFilter() {
      @Override
        public boolean accept(File dir, String name) {
        return name.matches(".*mov");
      }
    }
    );
  }
}

void movieEvent(Movie m) {
  m.read();
}