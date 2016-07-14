class WaveStarsPattern extends Scene
{
  float fadeValue = 0.3;

  //vars
  int orbitRadius = 50; // 100 is max

  int waveStrengthHorizontal= 5;
  int waveStrengthVertical= 5;

  float speed = 1;

  public void init()
  {
      waveStrengthHorizontal = (int)random(0, 20);
      waveStrengthVertical = (int)random(0, 20);
      
      println("vertical changed to " + waveStrengthVertical);
      println("horizontal changed to " + waveStrengthHorizontal);
  }

  public void update()
  {
    if (frameCount % 5 != 0)
      return;

    // change strength every 5 seconds
    /*
    if (frameCount % 300 == 0)
    {
      waveStrengthHorizontal = (waveStrengthHorizontal + 1) % 100;
      waveStrengthVertical = (waveStrengthVertical + 5) % 100;
      println("");
      println("vertical changed to " + waveStrengthVertical);
      println("horizontal changed to " + waveStrengthHorizontal);
    }
    */

    // iterate over every led
    for (int u = 0; u < tubes.size(); u++)
    {
      Tube t =  tubes.get(u);
      for (int v = 0; v < t.leds.size(); v++)
      {
        float strength = u * waveStrengthHorizontal + v * waveStrengthVertical;
        int finalSpeed = (int)(360 / speed);

        float angle = (float)((((frameCount + strength) % finalSpeed) * Math.PI) / 90);

        float x = (float)(orbitRadius * Math.cos(angle));
        float y = (float)(orbitRadius * Math.sin(angle));

        // set brightness by x value
        t.leds.get(v).c.fadeB((y + x) % 100, fadeValue);
      }
    }
  }
}