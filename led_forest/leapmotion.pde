import com.leapmotion.leap.*;
import com.leapmotion.leap.processing.LeapMotion;

LeapMotion leapMotion;

volatile Frame frame;
private final Object lock = new Object();

Frame getFrame()
{
  synchronized (lock) {
    return frame;
  }
}

void setupLeapMotion()
{
  leapMotion = new LeapMotion(this);
}

void onFrame(final Controller controller)
{
  synchronized (lock) {
    frame = controller.frame();
  }
}

void visualizeLeapMotion()
{
  if (frame.hands().count() > 0)
  {
    Hand h = frame.hands().get(0);
    Vector v = h.palmPosition();
    pushMatrix();
    translate(v.getX(), -v.getY() + 100, v.getZ());
    noStroke();
    fill(255);
    box(50, 50, 50);
    popMatrix();
  }
}