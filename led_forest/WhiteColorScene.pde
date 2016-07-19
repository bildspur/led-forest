class WhiteColorScene extends Scene
{
  float fadeSpeed = secondsToEasing(0.8);
  
  public String getName()
  {
     return "White Color Scene"; 
  }
  
  
  public void update()
  {
    if (frameCount % secondsToFrames(1) != 0)
      return;

    setColorS(0, fadeSpeed);
  }
}