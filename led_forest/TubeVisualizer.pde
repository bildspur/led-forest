class TubeVisualizer
{
  public int rodColumnCount = 3;
  public int rodRowCount = 5;

  // 3d vars
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

  PGraphics render2d()
  {
    PGraphics p = createGraphics(640, 480);
    p.beginDraw();
    for (int i = 0; i < rods.size(); i++)
    {
      Tube t = rods.get(i).tube;
      
      p.noStroke();
      p.fill(255);
      p.textSize(12);
      p.text(i, i * (wspace2d + width2d) + woffset, (hspace2d + height2d) + hoffset - (1.5 * height2d));

      for (int j = 0; j < t.leds.size(); j++)
      {
        LED l = t.leds.get(t.leds.size() - 1 - j);
        p.fill(l.c.getColor());
        p.rect(i * (wspace2d + width2d) + woffset, 
          j * (hspace2d + height2d) + hoffset, 
          width2d, height2d);
      }
    }
    p.endDraw();
    
    return p;
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
        println("creating column: " + z + " row: " + x + "...");
        
        PVector pos = new PVector(x * rodSpaceDistance - deltaX, 0, z * rodSpaceDistance - deltaZ);
        rods.add(new Rod(tubes.get((z * rodRowCount) + x), pos));
      }
    }
  }
}