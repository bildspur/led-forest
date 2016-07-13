import peasy.*;

PeasyCam cam;

public void setupPeasy()
{
  smooth();
  cam = new PeasyCam(this, 200);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
}