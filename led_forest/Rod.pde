class Rod
{
  float rodWidth = 1;
  float rodLength = 50;
  int rodDetail = 5;
  float ledLength;

  public PVector p;
  protected ArrayList<PShape> shapes;

  public Tube tube;

  public Rod(Tube tube, PVector position)
  {
    shapes = new ArrayList<PShape>();

    this.tube = tube;
    this.p = position;
    this.ledLength = rodLength / tube.leds.size();

    for (int i = 0; i < tube.leds.size(); i++)
    {
      PShape sh = createRod(rodWidth, ledLength, rodDetail);
      sh.disableStyle();
      shapes.add(sh);
    }
  }

  public void render()
  {
    for (int i = 0; i < shapes.size(); i++)
    {
      PShape sh = shapes.get(i);
      
      pushMatrix();
      translate(p.x, p.y + (i * ledLength), p.z);
      noStroke();
      fill(tube.leds.get(tube.leds.size() - 1 - i).c.getColor());

      sh.disableStyle();
      shape(sh);
      popMatrix();
    }
  }

  PShape createRod(float r, float h, int detail) {
    textureMode(NORMAL);
    PShape sh = createShape();
    sh.beginShape(QUAD_STRIP);
    for (int i = 0; i <= detail; i++) {
      float angle = TWO_PI / detail;
      float x = sin(i * angle);
      float z = cos(i * angle);
      float u = float(i) / detail;
      sh.normal(x, 0, z);
      sh.vertex(x * r, -h/2, z * r, u, 0);
      sh.vertex(x * r, +h/2, z * r, u, 1);
    }
    sh.endShape(); 
    return sh;
  }
}