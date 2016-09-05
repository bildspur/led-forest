import codeanticode.syphon.*;

SyphonServer syphon;

void setupSyphon()
{
  syphon = new SyphonServer(this, "Kleinlaut LED Controller");
}

void sendScreenToSyphon()
{
  loadPixels();
  syphon.sendScreen();
}

void sendImageToSyphon(PGraphics p)
{
  /*
  p.loadPixels();

  // Flip image back (very bad approach)
  PImage canvas = new PImage(p.width, p.height);
  for (int x = 0; x < p.width; x++) {
    for (int y = 0; y < p.height; y++) {
      canvas.pixels[((p.height-y-1)*p.width+x)] = p.pixels[y*p.width+x];
    }
  }

  syphon.sendImage(canvas);
  */
  syphon.sendImage(p);
}