public class Bullet extends Weapon
{
  PVector cellPosition;
  PVector positionOffset;
  
  Bullet(float x, float y, color colour, float speed, float damage)
  {
    super(x, y, colour, speed, damage);
    positionOffset = new PVector(0, 0);
  }
  Bullet()
  {
    super(0, 0, color(random(0, 255), random(0, 255), random(0, 255)), 0.1, 10);
  }
  
  public void render()
  {
    
  }
  public void update()
  {
    
  }
}