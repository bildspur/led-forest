class LED
{
  int address;
  FadeColor c;

  public LED( int address, color c)
  {
    this.address = address;
    this.c = new FadeColor(c);
  }
}