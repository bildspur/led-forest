class TubeVisualizer
{
  int rodColumnCount = 4;
  int rodRowCount = 4;

  float rodSpaceDistance = 50;

  ArrayList<Rod> rods;

  // 2d vars
  float wspace2d = 20;
  float hspace2d = 2;
  float width2d = 15;
  float height2d = 15;
  float hoffset = 50;
  float woffset = 50;

  void render3d()
  {
    for (Rod r : rods)
    {
      r.render();
    }
  }

  void render2d()
  {
    cam.beginHUD();
    for (int i = 0; i < rods.size(); i++)
    {
      Tube t = rods.get(i).tube;
      
      fill(255);
      textSize(12);
      text(i, i * (wspace2d + width2d) + woffset, (hspace2d + height2d) + hoffset - (1.5 * height2d));

      for (int j = 0; j < t.leds.size(); j++)
      {
        LED l = t.leds.get(t.leds.size() - 1 - j);
        fill(l.c.getColor());
        rect(i * (wspace2d + width2d) + woffset, 
          j * (hspace2d + height2d) + hoffset, 
          width2d, height2d);
      }
    }
    cam.endHUD();
  }

  void initRods(ArrayList<Tube> tubes)
  {
    rods = new ArrayList<Rod>();

    float deltaX = (rodSpaceDistance * rodRowCount) / 2f - (rodSpaceDistance / 2);
    float deltaZ = (rodSpaceDistance * rodColumnCount) / 2f - (rodSpaceDistance / 2);

    for (int z = 0; z < rodColumnCount; z++)
    {
      for (int x = 0; x < rodRowCount; x++)
      {
        PVector pos = new PVector(x * rodSpaceDistance - deltaX, 0, z * rodSpaceDistance - deltaZ);
        rods.add(new Rod(tubes.get((z * rodColumnCount) + x), pos));
      }
    }
  }
}