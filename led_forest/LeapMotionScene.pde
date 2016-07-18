class LeapMotionScene extends Scene
{
  float fadeSpeed = secondsToEasing(0.5); // 60 frames$
  float interactionRadius = 50;

  public String getName()
  {
    return "LeapMotion Scene";
  }

  public void init()
  {
    setColorS(0, fadeSpeed);
  }

  public void update()
  {
    Hand h = frame.hands().get(0);
    Vector v = h.palmPosition();
    PVector palmPosition = intBoxVector(v);
    
    // strength affects saturation
    setColorS(h.grabStrength() * 100, secondsToEasing(0.5));

    for (int j = 0; j < tubes.size(); j++)
    {
      Tube t =  tubes.get(j);
      for (int i = 0; i < t.leds.size(); i++)
      {
        LED led = t.leds.get(i);

        float distance = ledPosition(j, i).dist(palmPosition);

        if (distance < interactionRadius)
          led.c.fadeB(100, fadeSpeed);
        else
          led.c.fadeB(0, fadeSpeed);
      }
    }
  }

  public PVector ledPosition(int rodIndex, int ledIndex)
  {
    Rod r = visualizer.rods.get(rodIndex);
    float ledLength = r.ledLength;
    return new PVector(r.p.x, r.p.y + ((r.shapes.size() - ledIndex) * ledLength), r.p.z);
  }
}