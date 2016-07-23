import oscP5.*;
import netP5.*;

// OSC server and client
OscP5 osc;
NetAddress madMapper;
NetAddress apps;

float lastLuminosity = 100;
float lastResponse = 100;

void setupOSC()
{
  //init osc with default ports
  osc = new OscP5(this, 9000);
  madMapper = new NetAddress("127.0.0.1", 8000);
  apps = new NetAddress("255.255.255.255", 9001);
}

void oscEvent(OscMessage msg) {
  switch(msg.addrPattern())
  {
  case "/forest/luminosity":
    lastLuminosity = msg.get(0).floatValue();
    msg.setAddrPattern(msg.addrPattern() + "_mm");
    osc.send(msg, madMapper);
    break;

  case "/forest/flash":
    msg.setAddrPattern("/forest/luminosity_mm");
    lastLuminosity = msg.get(0).floatValue();
    osc.send(msg, madMapper);
    break;

  case "/forest/response":
    lastResponse = msg.get(0).floatValue();
    msg.setAddrPattern(msg.addrPattern() + "_mm");
    osc.send(msg, madMapper);
    break;

  case "/forest/haze":
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

  case "/forest/nextvideo":
    if (msg.get(0).floatValue() > 0)
    {
      println("Next Video!");
      videoScene.dispose();
      videoScene.init();
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

  case "/forest/update":
    if (msg.get(0).floatValue() > 0)
    {
      updateOSCApp();
    }
    break;
  }
}

public void updateOSCApp()
{
  sendMessage("/forest/luminosity", lastLuminosity);
  sendMessage("/forest/response", lastResponse);

  sendMessage("/forest/info/color", sceneManager.getActiveColorScene().getName());
  sendMessage("/forest/info/pattern", sceneManager.getActivePatternScene().getName());
  sendMessage("/forest/info/fps", "FPS: " + round(frameRate));

  if (frameCount % secondsToFrames(10) == 0)
    sendMessage("/forest/info/cpu", "CPU: " + getCPUTemperature() + "°C");
}

public void sendMessage(String address, float value)
{
  OscMessage m = new OscMessage(address);
  m.add(value);
  osc.send(m, apps);
}

public void sendMessage(String address, String value)
{
  OscMessage m = new OscMessage(address);
  m.add(value);
  osc.send(m, apps);
}