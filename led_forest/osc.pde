import oscP5.*;
import netP5.*;

// OSC server and client
OscP5 osc;
NetAddress madMapper;

void setupOSC()
{
  //init osc with default ports
  osc = new OscP5(this, 9000);
  madMapper = new NetAddress("127.0.0.1", 8000);
}

void oscEvent(OscMessage msg) {
  switch(msg.addrPattern())
  {
  case "/forest/luminosity":
    msg.setAddrPattern(msg.addrPattern() + "_mm");
    osc.send(msg, madMapper);
    break;

  case "/forest/response":
    msg.setAddrPattern(msg.addrPattern() + "_mm");
    osc.send(msg, madMapper);
    break;

  case "/forest/nextcolor":
    if (msg.get(0).floatValue() > 0)
    {
      println("Next Color!");
      sceneManager.nextColorScene();
    }
    break;

  case "/forest/nextlight":
    if (msg.get(0).floatValue() > 0)
    {
      println("Next Light!");
      sceneManager.nextPatternScene();
    }
    break;

  case "/forest/light":
    if (msg.get(0).floatValue() > 0)
    {
      println("Light up!");
      setColorToWhite();
    }
    break;


  case "/forest/black":
    if (msg.get(0).floatValue() > 0)
    {
      println("Blackout Light!");
      sceneManager.running = !sceneManager.running;
      setColor(color(100, 100, 0), secondsToEasing(1));
    }
    break;

  case "/forest/info":
    if (msg.get(0).floatValue() > 0)
    {
      showInfo = !showInfo;
    }
    break;

  case "/forest/2d":
    if (msg.get(0).floatValue() > 0)
    {
      drawMode = 2;
    }
    break;

  case "/forest/3d":
    if (msg.get(0).floatValue() > 0)
    {
      drawMode = 3;
    }
    break;

  case "/forest/normalmode":
    if (msg.get(0).floatValue() > 0)
    {
      sceneManager.normalMode = true;
      sceneManager.transitionMode = false;
    }
    break;
  }
}