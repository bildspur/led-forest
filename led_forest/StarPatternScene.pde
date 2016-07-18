class StarPatternScene extends Scene
{
  public String getName()
  {
    return "StarPattern Scene";
  }

  public void init()
  {
    setColorS(0, secondsToEasing(1));
  }

  public void update()
  {
    //if (frameCount % secondsToFrames(1) != 0)
      //return;
    
    for (int j = 0; j < tubes.size(); j++)
    {
      Tube t =  tubes.get(j);
      for (int i = 0; i < t.leds.size(); i++)
      {
        if (random(0, 1) > 0.99)
        {
          LED led = t.leds.get(i);
          float fadeSpeed = random(secondsToEasing(10), secondsToEasing(1));
          int intensity = (int)random(0, 100);
          led.c.fadeB(intensity, secondsToEasing(1));
        }
      }
    }
  }
}