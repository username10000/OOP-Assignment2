abstract public class GameObject
{
  PVector position;
  boolean isAlive;
  color colour;
  
  public GameObject(float x, float y, color colour)
  {
    position = new PVector(x, y);
    this.colour = colour;
    isAlive = true;
  }
  public GameObject()
  {
    this(width / 2, height / 2, color(0, 0, 0));
  }
  
  public abstract void render();
  public abstract void update();
}