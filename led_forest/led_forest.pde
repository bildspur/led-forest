ArrayList<Tube> tubes; //<>//
TubeVisualizer visualizer;

ArrayList<Scene> colorScenes;
ArrayList<Scene> patternScenes;

int currentColorScene = 0;
int currentPatternScene = 0;

int drawMode = 3;

void settings()
{
  size(640, 480, P3D);
  PJOGL.profile = 1;
}

void setup()
{
  setupSyphon();
  setupLeapMotion();
  setupPeasy();

  // settings
  ellipseMode(CENTER);
  frameRate(60);
  colorMode(HSB, 360, 100, 100);

  // setup tubes
  createTubes(16, 24);

  // mark some LEDS
  tubes.get(0).leds.get(0).c = new FadeColor(color(255, 0, 0));
  tubes.get(1).leds.get(0).c = new FadeColor(color(0, 255, 0));

  // visualizer
  visualizer = new TubeVisualizer();
  visualizer.initRods(tubes);

  // color Scenes and Patterns
  colorScenes = new ArrayList<Scene>();
  colorScenes.add(new HSVColorScene());

  patternScenes = new ArrayList<Scene>();
  patternScenes.add(new WavingPatternScene());
}

void draw()
{
  background(0);

  // scenes
  colorScenes.get(currentColorScene).update();
  patternScenes.get(currentPatternScene).update();

  updateLEDs();


  if (drawMode == 3)
  {
    visualizer.render3d();
  } else
  {
    visualizer.render2d();
  }

  sendImageToSyphon();

  // hud
  cam.beginHUD();
  fill(255);
  textSize(12);
  text("Draw Mode: " + drawMode + "D", 5, 15);
  text("FPS: " + round(frameRate), 5, 30);
  cam.endHUD();
}

void updateLEDs()
{
  for (Tube t : tubes)
  {
    for (LED l : t.leds)
    {
      l.c.update();
    }
  }
}

void createTubes(int tubeCount, int ledCount)
{
  tubes = new ArrayList<Tube>();
  int address = 0;
  int universe = 0;

  for (int i = 0; i < tubeCount; i++)
  {
    Tube t = new Tube(universe);
    tubes.add(t);

    int colorShift = 0;

    for (int j = 0; j < ledCount; j++)
    {
      colorShift += 10;
      LED led = new LED(address, color(100 + colorShift, 100, 100));
      t.leds.add(led);

      address += 3;
    }

    // break alle 300 led's (showjockey standard)
    if (300 - ((ledCount * 3) + address)  <= 0)
    {
      universe++;
      address = 0;
    }
  }
}

void keyPressed() {
  switch(key)
  {
  case '2':
    drawMode = 2;
    break;

  case '3':
    drawMode = 3;
    break;

  case ' ':
    color c = color(random(0, 360), random(0, 100), random(0, 100));
    for (int i = 0; i < tubes.get(0).leds.size(); i++)
    {
      tubes.get(0).leds.get(i).c.fade(c, 0.05);
    }
    break;

  case 'c':
    currentColorScene = 0;
    break;

  default:
    println("Key: " + key);
  }
}

void setRandomColor()
{
  color c = color(random(0, 360), random(0, 100), random(0, 100));
  println("Random Color: " + hue(c) + ", " + saturation(c) + ", " + brightness(c));
  for (int j = 0; j < tubes.size(); j++)
  {
    for (int i = 0; i < tubes.get(j).leds.size(); i++)
    {
      tubes.get(j).leds.get(i).c.fade(c, 0.01);
    }
  }
}