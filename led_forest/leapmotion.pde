import com.leapmotion.leap.*;
import com.leapmotion.leap.processing.LeapMotion;

LeapMotion leapMotion;

volatile Frame frame;
private final Object lock = new Object();

PVector interactionBox = new PVector(180, 180, 180);

ArrayList<PVector> handTargets = new ArrayList<PVector>();
ArrayList<PVector> handCurrents = new ArrayList<PVector>();

int lastHandsCount = -1;

//PVector handTarget = new PVector();
//PVector handCurrent = new PVector();
float handEasing = 0.1;

Frame getFrame()
{
  synchronized (lock) {
    return frame;
  }
}

void setupLeapMotion()
{
  leapMotion = new LeapMotion(this);
  
  for(int i = 0; i < 10; i++)
  {
     handTargets.add(new PVector());
     handCurrents.add(new PVector()); 
  }
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
  PVector ibv = new PVector(interactionBox.x * nv.x, 
    interactionBox.y * nv.y, 
    interactionBox.z * nv.z);

  PVector hbox = PVector.mult(interactionBox, 0.5);
  return new PVector(ibv.x - hbox.x, -1 * (ibv.y - hbox.y), ibv.z - hbox.z);
}

void visualizeLeapMotion()
{
  // Interaction box visualisation
  pushMatrix();
  stroke(255);
  noFill();
  box(interactionBox.x, interactionBox.y, interactionBox.z);
  popMatrix();
  
  // Create Targets
  /*
  if(lastHandsCount != frame.hands().count())
  {
      lastHandsCount = frame.hands().count();
      
  }
  */

  // Hand Visualisation
  if (isLeapMotionHandAvailable())
  {
    int hIndex = 0;
    for (Hand h : frame.hands())
    {
      //Hand h = frame.hands().get(0);
      Vector v = h.palmPosition();
      PVector ibv = intBoxVector(v);
      
      PVector handCurrent = handCurrents.get(hIndex);
      PVector handTarget = handTargets.get(hIndex);
      
      // easing
      handTarget = ibv;
      handCurrent.add(PVector.sub(handTarget, handCurrent).mult(handEasing));

      pushMatrix();
      translate(handCurrent.x, handCurrent.y, handCurrent.z);
      stroke(255, 100);
      noFill();
      sphere(15);
      popMatrix();
      
      hIndex++;
    }
  }
}

boolean isLeapMotionHandAvailable()
{
  return (frame != null && frame.hands().count() > 0);
}