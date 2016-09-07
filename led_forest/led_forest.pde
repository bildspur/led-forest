ArrayList<Tube> tubes; //<>//
TubeVisualizer visualizer;

SceneManager sceneManager;

int drawMode = 3;

int defaultFrameRate = 40;

boolean showLogo = true;
boolean showInfo = false;
boolean mappingMode = false;

int markedLEDTube = -1;

PImage logo;

VideoScene videoScene = new VideoScene();

void settings()
{
  //size(640, 480, P3D);
  fullScreen(P3D, 1);
  PJOGL.profile = 1;
}

void setup()
{ 
  setupSyphon();
  setupLeapMotion();
  setupPeasy();
  setupOSC();

  // load logo
  logo = loadImage("images/logotext.png");
  logo.resize(width / 6, 0);

  // settingsi
  //fullScreen();
  ellipseMode(CENTER);
  frameRate(defaultFrameRate);
  colorMode(HSB, 360, 100, 100);

  // setup tubes
  visualizer = new TubeVisualizer();
  createTubes(visualizer.rodColumnCount * visualizer.rodRowCount, 24);

  // mark some LEDS
  tubes.get(0).leds.get(0).c = new FadeColor(color(255, 0, 0));
  tubes.get(1).leds.get(0).c = new FadeColor(color(0, 255, 0));

  // visualizer
  visualizer.initRods(tubes);

  // scenes
  sceneManager = new SceneManager();

  // color scenes
  sceneManager.colorScenes.add(new SpaceColorScene());
  sceneManager.colorScenes.add(new SingleColorScene());
  sceneManager.colorScenes.add(videoScene);
  sceneManager.colorScenes.add(new WhiteColorScene());
  sceneManager.colorScenes.add(new ExampleScene());
  sceneManager.colorScenes.add(videoScene);
  sceneManager.colorScenes.add(new HSVColorScene());

  // pattern scenes
  sceneManager.patternScenes.add(new FloatingPatternScene());
  sceneManager.patternScenes.add(new StarPatternScene());
  sceneManager.patternScenes.add(new FallingTraceScene());
  sceneManager.patternScenes.add(new WaveStarsPattern());

  sceneManager.init();
}

void draw()
{
  background(0);

  // scenes
  //sceneManager.update();

  updateLEDs();

  // calculate syphon ouput
  PGraphics output2d = visualizer.render2d();
  sendImageToSyphon(output2d);

  if (drawMode == 3)
  {
    visualizer.render3d();
    visualizeLeapMotion();
  } else
  {
    cam.beginHUD();
    image(output2d, 0, 0);
    cam.endHUD();
  }

  if (showLogo)
  {
    cam.beginHUD();
    image(logo, (width / 2) - (logo.width / 2), height - logo.height - 10);
    cam.endHUD();
  }

  sceneManager.update();

  // update osc app
  if (frameCount % secondsToFrames(1) == 0)
    updateOSCApp();

  // hud
  if (showInfo)
  {
    if (drawMode == 3)
    {
      // draw stub info
      fill(255);
      textSize(12);

      for (int i = 0; i < visualizer.rods.size(); i++)
      {
        pushMatrix();
        Rod r = visualizer.rods.get(i);
        translate(r.p.x, 0, r.p.z);
        text(r.tube.universe + "|" + i, 0, 0);
        popMatrix();
      }
    }

    cam.beginHUD();
    fill(255);
    textSize(12);
    text("Draw Mode: " + drawMode + "D", 5, 15);
    text("FPS: " + round(frameRate), 5, 30);
    text("Color Scene: " + sceneManager.getActiveColorScene().getName(), 150, 15);
    text("Pattern Scene: " + sceneManager.getActivePatternScene().getName(), 150, 30);
    cam.endHUD();
  }
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
      colorShift += 5;
      LED led = new LED(address, color(200 + colorShift, 100, 100));
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
      tubes.get(0).leds.get(i).c.fade(c, secondsToEasing(0.3));
    }
    break;

  case 'c':
    sceneManager.nextColorScene();
    break;

  case 'p':
    sceneManager.nextPatternScene();
    break;

  case 'i':
    showInfo = !showInfo;
    break;

  case 'm':
    mappingMode = !mappingMode;
    sceneManager.running = !sceneManager.running;
    setColor(color(100, 100, 100), 1);
    break;

  case 'b':
    for (int j = 0; j < tubes.size(); j++)
    {
      markTube(j, color(0, 0, 0));
    }
    break;

  case 'n':
    if (markedLEDTube >= 0)
      markTube(markedLEDTube, color(0, 0, 0));
    markedLEDTube = (markedLEDTube + 1) % tubes.size();
    println("marking tube nr.: " + markedLEDTube);
    markTube(markedLEDTube, color(0, 100, 100));
    break;

  case 'l':
    setColorToWhite();
    break;

  case 'v':
    videoScene.dispose();
    videoScene.init();
    break;

  case 'z':
    // set color for led 0
    for (int j = 0; j < tubes.size(); j++)
    {
      tubes.get(j).leds.get(0).c.fade(color(255), secondsToEasing(0.5));
    }
    break;

  default:
    println("Key: " + key);
  }
}

void markTube(int tubeId, int c)
{
  for (int i = 0; i < tubes.get(0).leds.size(); i++)
  {
    tubes.get(tubeId).leds.get(i).c.fade(c, secondsToEasing(0.3));
  }
}

float secondsToEasing(float seconds)
{
  return 1.0 / (seconds * defaultFrameRate);
}

int secondsToFrames(float seconds)
{
  return (int)(seconds * defaultFrameRate);
}