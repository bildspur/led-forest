
void setColor(color c, float fadeTime)
{
  println("Setting Color: " + hue(c) + ", " + saturation(c) + ", " + brightness(c));
  for (int j = 0; j < tubes.size(); j++)
  {
    for (int i = 0; i < tubes.get(j).leds.size(); i++)
    {
      tubes.get(j).leds.get(i).c.fade(c, fadeTime);
    }
  }
}

void setColorH(float c, float fadeTime)
{
  for (int j = 0; j < tubes.size(); j++)
  {
    for (int i = 0; i < tubes.get(j).leds.size(); i++)
    {
      tubes.get(j).leds.get(i).c.fadeH(c, fadeTime);
    }
  }
}

void setColorS(float c, float fadeTime)
{
  for (int j = 0; j < tubes.size(); j++)
  {
    for (int i = 0; i < tubes.get(j).leds.size(); i++)
    {
      tubes.get(j).leds.get(i).c.fadeS(c, fadeTime);
    }
  }
}

void setColorB(float c, float fadeTime)
{
  for (int j = 0; j < tubes.size(); j++)
  {
    for (int i = 0; i < tubes.get(j).leds.size(); i++)
    {
      tubes.get(j).leds.get(i).c.fadeB(c, fadeTime);
    }
  }
}


void setRandomColor(float fadeTime)
{
  color c = color(random(0, 360), random(0, 100), random(0, 100));
  setColor(c, fadeTime);
}