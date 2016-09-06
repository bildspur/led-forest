import peasy.*;

PeasyCam cam;

public void setupPeasy()
{
  smooth();
  cam = new PeasyCam(this, 100, 0, 0, 200);
  //cam.rotateX(radians(-20));
  cam.lookAt(0, 0, 0, 200, 5000);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
}