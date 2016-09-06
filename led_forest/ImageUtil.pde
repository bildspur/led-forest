public  void centerImage(PGraphics g, PImage img)
{
  centerImage(g, img, img.width, img.height);
}

public  void centerImageAdjusted(PGraphics g, PImage img)
{
  float scaleFactor;

  if (img.height > img.width)
    scaleFactor = (float)g.height / img.height;
  else
    scaleFactor = (float)g.width / img.width;

  centerImage(g, img, scaleFactor * img.width, scaleFactor * img.height);
}

public  void centerImage(PGraphics g, PImage img, float width, float height)
{
  g.image(img, (g.width / 2.0f) - (width / 2.0f), (g.height / 2.0f) - (height / 2.0f), width, height);
}