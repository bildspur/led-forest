class WavingPatternScene extends Scene
{
  int layerCount = 24;
  int activeLayer = 23;
  int addValue = -1;
  
  int trace = 15;
  
  float fadeValue = 0.3;

  public void update()
  {
    // do something every second
    if (frameCount % 5 != 0)
      return;
    
    for(int i = 0; i < trace; i++)
    {
        setLayer((activeLayer + i) % layerCount, color(255 - (255 / (trace - 1) * i)));
    }
    
    activeLayer += addValue;
    
    if(activeLayer < 0)
    {
       activeLayer = 23;
       addValue *= 1;
    }
    
    if(activeLayer >= layerCount)
    {
       activeLayer = 23;
    }
  }
  
  void setLayer(int layer, color c)
  {
    for (int j = 0; j < tubes.size(); j++)
    {
      Tube t =  tubes.get(j);
      t.leds.get(layer).c.fadeB(brightness(c), fadeValue);
    }
  }
}