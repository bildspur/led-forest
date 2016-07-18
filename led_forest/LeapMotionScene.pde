class LeapMotionScene extends Scene
{
  float fadeSpeed = secondsToEasing(1); // 60 frames
  int h = 0;
  
  public String getName()
  {
     return "LeapMotion Scene"; 
  }
  
  public void init()
  {
      setColor(color(0), 0.002);
  }

  public void update()
  {
    for (int j = 0; j < tubes.size(); j++)
    {
      Tube t =  tubes.get(j);
      for (int i = 0; i < t.leds.size(); i++)
      {
        LED led = t.leds.get(i);
        led.c.fadeH((h + ((360 / tubes.size()) * j)) % 360, fadeSpeed);
       
        led.c.fadeS((4*i), fadeSpeed);
      }
    }
    
    h += 300;
    
    if(h > 360)
    {
       h = h % 360;
    }
  }
}