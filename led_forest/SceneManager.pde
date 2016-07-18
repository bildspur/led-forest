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

  Scene leapMotionScene = new LeapMotionScene();

  public SceneManager()
  {
    colorScenes = new ArrayList<Scene>();
    patternScenes = new ArrayList<Scene>();
  }

  public void init()
  {
  }

  public void nextColorScene()
  {
    currentColorScene = (currentColorScene + 1) % colorScenes.size();
  }

  public void nextPatternScene()
  {
    currentPatternScene = (currentPatternScene + 1) % patternScenes.size();
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
    boolean isLeapAv = isLeapMotionHandAvailable();

    // go to leapmotion mode
    if (isLeapAv && !transitionMode && normalMode)
    {
      println("switching to leapmotion mode");
      
      transitionMode = true;
      sceneTimer = leapMotionTransitionTime;
      setColor(0, secondsToEasing(transitionTime));
    }

    // after transition
    if (transitionMode && sceneTimer == 0)
    {
      println("switched to leap motion");
      normalMode = false;
      transitionMode = false;
      leapMotionScene.init();
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
      colorScenes.get(currentColorScene).update();
      patternScenes.get(currentPatternScene).update();

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