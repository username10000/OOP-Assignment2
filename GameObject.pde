public class GameObject
{
  PVector position;
  boolean isAlive;
  
  public GameObject(float x, float y)
  {
    position = new PVector(x, y);
    isAlive = true;
  }
  public GameObject()
  {
    this(width / 2, height / 2);
  }
}