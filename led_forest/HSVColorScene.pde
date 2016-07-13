class HSVColorScene extends Scene
{
  int h = 0;
  float fadeSpeed = 0.02;

  public void update()
  {
    // do something every second
    if (frameCount % 60 != 0)
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
    h = h > 360 ? 0 : h + 20;
  }
}