abstract class Scene
{

  public boolean isUnique()
  {
     return false; 
  }
  
  public String getName()
  {
     return "Unnamed Scene"; 
  }
  
  // will be called when the scene gets enabled
  public void init()
  {
  }

  // will be called every frame
  public void update()
  {
  }
  
  // will be called when the scene gets stopped
  public void dispose()
  {
  }
}