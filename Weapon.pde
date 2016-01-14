abstract public class Weapon extends GameObject
{
  float speed;
  float damage;
  
  Weapon(float x, float y, color colour, float speed, float damage)
  {
    super(x, y, colour);
    this.speed = speed;
    this.damage = damage;
  }
  Weapon()
  {
    this(0, 0, color(random(0, 255), random(0, 255), random(0, 255)), 0.1, 10);
  }
  
  abstract public void render();
  abstract public void update();
}