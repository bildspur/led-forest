class FloatingPatternScene extends Scene
{
  float fadeSpeed = secondsToEasing(0.1);

  float[][] heightMap;
  float[][] velMap;
  float gravity=0.1;
  int[] sel=null;
  int zeroHeight = 15;

  public String getName()
  {
    return "Floating Pattern Scene";
  }

  public void init()
  {
    heightMap = new float[6][6];
    velMap = new float[6][6];
  }


  public void update()
  {    
    //if (frameCount % secondsToFrames(0.1) != 0)
    //  return;

    updateVelocityAndHeight();
    
    if(random(0, 1) > 0.99)
    {
       heightMap[(int)random(1, 3)][(int)random(1, 3)] = random(1, 10); 
    }

    for (int j = 0; j < tubes.size(); j++)
    {
      float h = heightMap[j / 4][j%4];
      for (int i = 0; i < tubes.get(j).leds.size(); i++)
      {      
        if (i < h + zeroHeight)
        {
          tubes.get(j).leds.get(i).c.fadeB(100, fadeSpeed);
        } else
        {
          tubes.get(j).leds.get(i).c.fadeB(0, fadeSpeed);
        }
      }
    }
  }


  void updateVelocityAndHeight()
  {
    int y, x;
    for (y=0; y < 4; y++) {
      for (x=0; x < 4; x++) {
        if (sel != null && sel[0] == x && sel[1] == y) continue;
        float h = heightMap[x][y];
        //float v = velMap[x][y];
        int x1=0;
        int y1=0;

        float f=0;
        for (y1=-1; y1<2; y1++) {
          for (x1=-1; x1<2; x1++) {
            if (x+x1 > 0 && x+x1 < 19 && y+y1 > 0 && y+y1 < 19 && (x1 != 0 || y1 != 0)) {
              f += heightMap[x+x1][y+y1];
            }
          }
        }
        f/=8;
        f = (f-h)/10;

        velMap[x][y] -= f;
        velMap[x][y] *= 0.95; //0.95;

        heightMap[x][y]-=velMap[x][y];
      }
    }
  }
}