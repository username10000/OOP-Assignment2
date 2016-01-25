public class TowerBullet extends Tower implements DamageUp, SpeedUp, RangeUp
{
  TowerBullet(int x, int y)
  {
    super(x, y);
    speed = 1;
    damage = 25;
    colour = color(255, 0, 0);
    drawShape();
    type = 0;
  }
  TowerBullet()
  {
    this(0, 0);
  }
  
  public void update()
  {
    // Find if there is an enemy nearby and if there is fire at it
    if (millis() > lastFired + 1000 * speed)
    {
      for (int i = 0 ; i < objects.size() ; i++)
      {
        if (objects.get(i) instanceof Enemy && dist(objects.get(i).position.x, objects.get(i).position.y, position.x, position.y) < fieldRadius)
        {
          float lengthY = position.y - objects.get(i).position.y;
          float lengthX = position.x - objects.get(i).position.x;
          Bullet bullet = new Bullet(cellPosition.x, cellPosition.y, colour, 0.2, damage);
          bullet.direction = new PVector(lengthX / 15, lengthY / 15);
          bullet.fieldRadius = fieldRadius;
          weapons.add(bullet);
          break;
        }
      }
      lastFired = millis();
    }
  }
    
  public void DamageIncrease()
  {
    damage += 25;
    upgradeLevel[0] ++;
  }
  
  public void SpeedIncrease()
  {
    speed -= 0.25;
    upgradeLevel[1] ++;
  }
  
  public void RangeIncrease()
  {
    fieldRadius += cellSize;
    upgradeLevel[2] ++;
  }
}