import com.leapmotion.leap.*;
import com.leapmotion.leap.processing.LeapMotion;

LeapMotion leapMotion;

volatile Frame frame;
private final Object lock = new Object();

PVector interactionBox = new PVector(180, 180, 180);

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

PVector normPVector(Vector v)
{
  Vector np = frame.interactionBox().normalizePoint(v, true);
  return new PVector(np.getX(), np.getY(), np.getZ());
}

PVector intBoxVector(Vector v)
{
  PVector nv = normPVector(v);
  return new PVector(interactionBox.x * nv.x, 
    interactionBox.y * nv.y, 
    interactionBox.z * nv.z);
}

void visualizeLeapMotion()
{
  // test
  pushMatrix();
  //translate(v.getX(), -v.getY() + 100, v.getZ());
  stroke(255);
  noFill();
  box(interactionBox.x, interactionBox.y, interactionBox.z);
  popMatrix();

  if (frame != null)
  {
    if (frame.hands().count() > 0)
    {
      Hand h = frame.hands().get(0);
      Vector v = h.palmPosition();
      pushMatrix();
      PVector ibv = intBoxVector(v);
      PVector hbox = PVector.mult(interactionBox, 0.5);
      translate(ibv.x - hbox.x, -1 * (ibv.y - hbox.y), ibv.z - hbox.z);
      noStroke();
      fill(255);
      box(15, 15, 15);
      popMatrix();
    }
  }
}