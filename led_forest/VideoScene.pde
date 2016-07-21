import processing.video.*;

class VideoScene extends Scene
{
  String[] videoFiles;
  int activeVideoIndex = -1;

  Movie activeVideo;

  public boolean isUnique()
  {
    return true;
  }

  public String getName()
  {
    return "Video Scene";
  }

  public void init()
  {
    videoFiles = readVideoFiles();

    if (videoFiles.length > 0)
    {
      activeVideoIndex = (activeVideoIndex + 1) % videoFiles.length;
      activeVideo = new Movie(led_forest.this, videoFiles[activeVideoIndex]);
      activeVideo.loop();
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

    cam.beginHUD();
    image(activeVideo, 0, 0);
    tint(255, 255);
    cam.endHUD();
  }

  String[] readVideoFiles()
  {
    java.io.File folder = new java.io.File(sketchPath("data"));
    return folder.list();
  }
}

void movieEvent(Movie m) {
  m.read();
}