class HSVColorScene extends Scene
{
  int h = 0;

  public void update()
  {
    // do something every second
    if (frameCount % 60 != 0)
      return;

    colorMode(HSB, 360, 100, 100);

    for (int j = 0; j < tubes.size(); j++)
    {
      Tube t =  tubes.get(j);
      for (int i = 0; i < t.leds.size(); i++)
      {
        color c = color(h, 4 * i, 100);
        t.leds.get(i).c.fade(c, 0.01);
      }
    }
    
    colorMode(RGB);
    
    h = h > 360 ? 0 : h + 20;
  }
}