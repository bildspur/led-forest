class HSVColorScene extends Scene
{
  int h = 0;
  float fadeSpeed = secondsToEasing(0.8);

  public String getName()
  {
    return "HSV Color Scene";
  }
  public void init() {
  }
  public void update()
  {
    // do something every second
    if (frameCount % secondsToFrames(1) != 0)
      return;

    // iterate over every led
    for (int j = 0; j < tubes.size(); j++)
    {
      Tube t =  tubes.get(j);
      for (int i = 0; i < t.leds.size(); i++)
      {
        LED led = t.leds.get(i);
        led.c.fadeH(h, fadeSpeed);
        led.c.fadeS(100 - (4*i), fadeSpeed);
      }
    }

    // update colorwheel
    h = (h + 20) % 361;
  }
}