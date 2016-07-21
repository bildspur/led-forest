class TutorialScene extends Scene
{
  PImage tutorialImage;

  public String getName()
  {
    return "Tutorial Scene";
  }

  public void init()
  {
    tutorialImage = loadImage("images/tutorial.png");
    tutorialImage.resize(0, height);
  }

  public void update()
  {
    cam.beginHUD();
    image(tutorialImage, 0, 0);
    cam.endHUD();
  }
}