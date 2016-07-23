public String execCmd(String cmd) throws java.io.IOException {
  java.util.Scanner s = new java.util.Scanner(Runtime.getRuntime().exec(cmd).getInputStream()).useDelimiter("\\A");
  return s.hasNext() ? s.next() : "";
}

public String getCPUTemperature()
{
  try
  {
    //gem install iStats
    //sudo find / -name "iStats"
    
    String s = execCmd("/Library/Ruby/Gems/2.0.0/gems/iStats-1.2.0/bin/istats cpu temp");
    String temp = s.substring(10, s.indexOf("°") - 1);
    return temp;
  } 
  catch(Exception ex)
  {
    println(ex);
    return "N/A";
  }
}