class FadeColor
{
  PVector current = new PVector();
  PVector target = new PVector();
  
  float easing = 0.05;
  
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
    current.add(delta.mult(easing));
  }
  
  public void setColor(color c)
  {
     current = colorToVector(c);
     target = colorToVector(c);
  }
  
  public void fade(color t, float easing)
  {
    this.easing = easing;
    this.target = colorToVector(t);
  }
  
  public color getColor()
  {
     return vectorToColor(current); 
  }
  
  private PVector colorToVector(color c)
  {
    return new PVector(red(c), green(c), blue(c));
  } 
  
  private color vectorToColor(PVector v)
  {
     return color(round(v.x), round(v.y), round(v.z));
  }
}