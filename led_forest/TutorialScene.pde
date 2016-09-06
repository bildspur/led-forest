class TutorialScene extends Scene
{
  PImage tutorialImage;
  
  public Animation fade;

  public String getName()
  {
    return "Tutorial Scene";
  }

  public void init()
  {
    tutorialImage = loadImage("images/tutorial.png");
    
    fade = new Animation(0.5, 0, 255);
    fade.start();
  }

  public void update()
  {
    fade.update();
    
    cam.beginHUD();
    tint(255, fade.getValue());
    centerImageAdjusted(led_forest.this.g, tutorialImage);
    cam.endHUD();
  }
}