public class SceneManager extends Scene
{
  ArrayList<Scene> colorScenes;
  ArrayList<Scene> patternScenes;

  int transitionTime = 2;

  int currentColorScene = 0;
  int currentPatternScene = 0;

  int colorCycle = secondsToFrames(2*60);
  int patternCycle = secondsToFrames(60);

  int leapMotionIdleTime = secondsToFrames(10);
  int leapMotionIdleTimer = leapMotionIdleTime;
  int leapMotionTransitionTime = secondsToFrames(transitionTime);

  int sceneTimer = 0;

  boolean transitionMode = false;
  boolean normalMode = true;

  boolean running = true;

  Scene leapMotionScene = new LeapMotionScene();
  Scene tutorialScene = new TutorialScene();

  public SceneManager()
  {
    colorScenes = new ArrayList<Scene>();
    patternScenes = new ArrayList<Scene>();
  }

  public void init()
  {
    getActiveColorScene().init();
    getActivePatternScene().init();
  }

  public void nextColorScene()
  {
    getActiveColorScene().dispose();
    currentColorScene = (currentColorScene + 1) % colorScenes.size();
    getActiveColorScene().init();
  }

  public void nextPatternScene()
  {
    getActivePatternScene().dispose();
    currentPatternScene = (currentPatternScene + 1) % patternScenes.size();
    getActivePatternScene().init();
  }

  public Scene getActiveColorScene()
  {
    if (normalMode)
      return colorScenes.get(currentColorScene);
    else
      return leapMotionScene;
  }

  public Scene getActivePatternScene()
  {
    if (normalMode)
      return patternScenes.get(currentPatternScene);
    else
      return leapMotionScene;
  }

  public void update()
  {
    // do nothing if not running
    if (!running)
      return;

    boolean isLeapAv = isLeapMotionHandAvailable();

    // go to leapmotion mode
    if (isLeapAv && !transitionMode && normalMode)
    {
      println("switching to leapmotion mode");
      
      getActiveColorScene().dispose();
      getActivePatternScene().dispose();

      transitionMode = true;
      sceneTimer = leapMotionTransitionTime;
      setColor(0, secondsToEasing(transitionTime));

      leapMotionScene.init();
      tutorialScene.init();
    }

    // after transition
    if (transitionMode && sceneTimer == 0)
    {
      println("switched to leap motion");
      normalMode = false;
      transitionMode = false;
      leapMotionScene.init();
    }

    //during transition
    if (transitionMode && sceneTimer > 0)
    {
      tutorialScene.update();
    }

    // decrease idle time
    if (!isLeapAv && !normalMode)
    {
      leapMotionIdleTimer--;

      if (leapMotionIdleTimer == 0)
      {
        println("switched to normal");
        normalMode = true;
      }
    }

    // reset idle time
    if (isLeapAv && !normalMode)
    {
      leapMotionIdleTimer = leapMotionIdleTime;
    }

    // update in leapmotion mode
    if (!normalMode && !transitionMode)
    {
      leapMotionScene.update();
    }

    // update in normal mode
    if (normalMode && !transitionMode)
    {

      Scene cs = colorScenes.get(currentColorScene);
      cs.update();

      if (!cs.isUnique())
      {
        Scene ps = patternScenes.get(currentPatternScene);
        ps.update();
      }

      if (frameCount % colorCycle == 0)
        nextColorScene();

      if (frameCount % patternCycle == 0)
        nextPatternScene();
    }

    // decrease scene timer
    if (sceneTimer > 0)
    {
      sceneTimer--;
    }
  }
}