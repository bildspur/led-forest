class LeapMotionScene extends Scene
{
  float fadeSpeed = secondsToEasing(0.5);
  
  
  float fadeSpeedH = secondsToEasing(0.1);
  float fadeSpeedS = secondsToEasing(0.1);
  float fadeSpeedBIn = secondsToEasing(0.3);
  float fadeSpeedBOut = secondsToEasing(0.1);
  
  
  float interactionRadius = 50;

  int hue = 0;

  public String getName()
  {
    return "LeapMotion Scene";
  }

  public void init()
  {
    setColorS(0, fadeSpeed);
    setColorH(0, fadeSpeedH);
  }

  public void update()
  {
    PVector[] palms = new PVector[frame.hands().count()];

    // update palms
    for (int i = 0; i < palms.length; i++)
    {
      Hand h = frame.hands().get(i);
      Vector v = h.palmPosition();
      PVector palmPosition = intBoxVector(v);
      palms[i] = palmPosition;
    }

    // interactionRadius = map(palmPosition.y * -1, 0, interactionBox.y / 2, 50, 300);

    // strength affects saturation
    //setColorS(h.grabStrength() * 100, secondsToEasing(0.5));

    //setColorH(hue, secondsToEasing(0.5));

    for (int j = 0; j < tubes.size(); j++)
    {
      Tube t =  tubes.get(j);
      for (int i = 0; i < t.leds.size(); i++)
      {
        LED led = t.leds.get(i);

        boolean isOn = false;
        float minDistance = Float.MAX_VALUE;
        int nearestHandIndex = 0;

        // check if a palm is nearby
        for (int p = 0; p < palms.length; p++)
        {
          float distance = ledPosition(j, (t.leds.size() - 1 - i)).dist(palms[p]);
          if (distance < interactionRadius)
          {
            if (minDistance > distance)
            {
              minDistance = distance;
              nearestHandIndex = p;
            }

            isOn = true;
          }
        }

        if (isOn)
        {
          Hand h = frame.hands().get(nearestHandIndex);

          led.c.fadeH(getHueByHand(h), fadeSpeedH);
          led.c.fadeS(100 - (h.grabStrength() * 100), fadeSpeedS);
          led.c.fadeB(100, fadeSpeedBIn);
        } else
        {
          /*
          led.c.fadeH(getHueByHand(h), fadeSpeedH);
          led.c.fadeS(100 - (h.grabStrength() * 100), fadeSpeedS);
          */
          //led.c.fadeS(0, fadeSpeedS);
          led.c.fadeB(0, fadeSpeedBOut);
        }
      }
    }

    if (frameCount % secondsToFrames(1) == 0)
      hue = (hue + 1) % 360;
  }

  float getHueByHand(Hand h)
  {
    float roll = Math.abs(h.palmNormal().roll());
    return map(roll, 0, PI, 0, 360);
  }

  public PVector ledPosition(int rodIndex, int ledIndex)
  {
    Rod r = visualizer.rods.get(rodIndex);
    float ledLength = r.ledLength;
    return new PVector(r.p.x, r.p.y + ((r.shapes.size() - ledIndex) * ledLength), r.p.z);
  }
}