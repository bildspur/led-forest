class StarPatternScene extends Scene
{
  float randomOnFactor = 0.95;
  float randomOffFactor = 0.8;

  public String getName()
  {
    return "StarPattern Scene";
  }

  public void init()
  {
    setColorB(0, secondsToEasing(1));
  }

  public void update()
  {
    if (frameCount % secondsToFrames(0.5) != 0)
      return;

    for (int j = 0; j < tubes.size(); j++)
    {
      Tube t =  tubes.get(j);
      for (int i = 0; i < t.leds.size(); i++)
      {
        LED led = t.leds.get(i);

        float ledBrightness = brightness(led.c.getColor());
        float fadeSpeed = 1; //random(secondsToEasing(10), secondsToEasing(1));

        if (ledBrightness > 10)
        {
          //led is ON
          if (random(0, 1) > randomOffFactor)
          {
            led.c.fadeB(0, secondsToEasing(fadeSpeed));
          }
        } else
        {
          //led is OFF
          if (random(0, 1) > randomOnFactor)
          {
            led.c.fadeB(random(50, 100), secondsToEasing(fadeSpeed));
          }
        }
      }
    }
  }
}