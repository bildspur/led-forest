public class SceneManager extends Scene
{
  ArrayList<Scene> colorScenes;
  ArrayList<Scene> patternScenes;

  int transitionTime = 2;

  int currentColorScene = 0;
  int currentPatternScene = 0;

  int colorCycle = secondsToFrames(4*60);
  int patternCycle = secondsToFrames(2*60);

  int leapMotionIdleTime = secondsToFrames(10);
  int leapMotionIdleTimer = leapMotionIdleTime;
  int leapMotionTransitionTime = secondsToFrames(transitionTime);

  int sceneTimer = 0;

  boolean transitionMode = false;
  boolean normalMode = true;

  boolean running = true;

  Scene leapMotionScene = new LeapMotionScene();
  Scene tutorialScene = new TutorialScene();

  SceneMode currentMode;

  public SceneManager()
  {
    colorScenes = new ArrayList<Scene>();
    patternScenes = new ArrayList<Scene>();

    currentMode = new NormalMode(this);
  }

  public void init()
  {
    currentMode.init();
  }

  public void changeMode(SceneMode newMode)
  {
    currentMode.close();
    currentMode = newMode;
    currentMode.init();
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
    if (!running)
      return;

    currentMode.update();
  }
}