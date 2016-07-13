class FadeColor
{
  /* Importent: This is for HSB only! */
  final float hmax = 360;

  PVector current = new PVector();
  PVector target = new PVector();
  PVector easingVector = new PVector();

  public FadeColor()
  {
  }

  public FadeColor(color c)
  {
    current = colorToVector(c);
    target = colorToVector(c);
  }

  public void update()
  {
    PVector delta = target.copy().sub(current);

    // Hue => 360° (can ease to both sides)
    float otherDelta = hmax - Math.abs(delta.x);

    if (Math.abs(otherDelta) < Math.abs(delta.x))
    {
      delta.x = otherDelta * (delta.x < 0 ? 1 : -1);
    }

    // no matrix multiplication possible
    current.x = (current.x + delta.x * easingVector.x) % hmax;
    current.x = current.x < 0 ? 360 + current.x : current.x;

    current.y += delta.y * easingVector.y;
    current.z += delta.z * easingVector.z;
  }

  public void setColor(color c)
  {
    current = colorToVector(c);
    target = colorToVector(c);
  }

  public void fade(color t, float easing)
  {
    easingVector = new PVector(easing, easing, easing);
    this.target = colorToVector(t);
  }

  public void fadeH(float h, float easing)
  {
    easingVector.x = easing;
    target.x = h;
  }

  public void fadeS(float s, float easing)
  {
    easingVector.y = easing;
    target.y = s;
  }

  public void fadeB(float b, float easing)
  {
    easingVector.z = easing;
    target.z = b;
  }

  public color getColor()
  {
    return vectorToColor(current);
  }

  private PVector colorToVector(color c)
  {
    return new PVector(hue(c), saturation(c), brightness(c));
  } 

  private color vectorToColor(PVector v)
  {
    return color(round(v.x), round(v.y), round(v.z));
  }
}