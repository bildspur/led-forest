class FadeColor
{
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
    
    // no matrix multiplication possible
    current.x += delta.x * easingVector.x;
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