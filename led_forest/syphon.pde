import codeanticode.syphon.*;

SyphonServer syphon;

void setupSyphon()
{
   syphon = new SyphonServer(this, "Kleinlaut LED Controller");
}

void sendImageToSyphon()
{
  loadPixels();
  syphon.sendScreen();
}