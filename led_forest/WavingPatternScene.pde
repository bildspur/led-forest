class WavingPatternScene extends Scene
{
  int layerCount = 24;
  int activeLayer = 23;
  int lastLayer = 23;
  int addValue = -1;
  
  float fadeValue = 0.1;

  public void update()
  {
    // do something every second
    if (frameCount % 10 != 0)
      return;
    
    setLayer(lastLayer, color(0));
    setLayer(activeLayer, color(255));
    
    lastLayer = activeLayer;
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
      t.leds.get(layer).c.fade(c, fadeValue);
    }
  }
}