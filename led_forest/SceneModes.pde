public abstract class SceneMode
{
  SceneManager sceneManager;
  int timer = 0;

  public SceneMode(SceneManager sceneManager)
  {
    this.sceneManager = sceneManager;
  }

  public void init() {
  }

  public void update() {
    timer++;
  }

  public void close() {
  }
}

public class NormalMode extends SceneMode
{

  public NormalMode(SceneManager sceneManager)
  {
    super(sceneManager);
  }

  public void init()
  {
    println("switching to normal mode");
    
    sceneManager.getActiveColorScene().init();
    sceneManager.getActivePatternScene().init();
  }

  public void update()
  {
    super.update();

    if (isLeapMotionHandAvailable())
      sceneManager.changeMode(new TutorialMode(sceneManager));

    Scene cs = sceneManager.getActiveColorScene();
    cs.update();

    if (!cs.isUnique())
    {
      Scene ps = sceneManager.getActivePatternScene();
      ps.update();
    }

    if (frameCount % sceneManager.colorCycle == 0)
      sceneManager.nextColorScene();

    if (frameCount % sceneManager.patternCycle == 0)
      sceneManager.nextPatternScene();
  }

  public void close()
  {
    sceneManager.getActiveColorScene().dispose();
    sceneManager.getActivePatternScene().dispose();
  }
}

public class LeapMode extends SceneMode
{
  int leapMotionIdleTimer;

  public LeapMode(SceneManager sceneManager)
  {
    super(sceneManager);
  }

  public void init()
  {
    println("switching to leapmotion mode");
    sceneManager.leapMotionScene.init();
    leapMotionIdleTimer = sceneManager.leapMotionIdleTime;
  }

  public void update()
  {
    super.update();
    sceneManager.leapMotionScene.update();

    if (isLeapMotionHandAvailable())
      leapMotionIdleTimer =  sceneManager.leapMotionIdleTime;

    if (leapMotionIdleTimer < 0)
      sceneManager.changeMode(new NormalMode(sceneManager));

    leapMotionIdleTimer--;
  }

  public void close()
  {
    sceneManager.leapMotionScene.dispose();
  }
}

public class TutorialMode extends SceneMode
{
  float fadeTime = 0.5;
  int beginFade;
  TutorialScene tutScene;

  public TutorialMode(SceneManager sceneManager)
  {
    super(sceneManager);
  }

  public void init()
  {
    println("switching to tutorial mode");
    setColor(0, secondsToEasing(sceneManager.transitionTime));
    sceneManager.tutorialScene.init();
    beginFade = secondsToFrames(fadeTime);
    
    tutScene = ((TutorialScene)sceneManager.tutorialScene);
  }

  public void update()
  {
    super.update();
    sceneManager.tutorialScene.update();
    
    // do fadeout
    if (sceneManager.leapMotionTransitionTime - timer < beginFade && !tutScene.fade.isRunning())
    {
      println("start fading..");
      tutScene.fade = new Animation(fadeTime, 255, 0);
      tutScene.fade.start();
    }

    if (timer > sceneManager.leapMotionTransitionTime)
      sceneManager.changeMode(new LeapMode(sceneManager));
  }

  public void close()
  {
    sceneManager.tutorialScene.dispose();
  }
}