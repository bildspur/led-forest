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