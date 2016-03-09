public class Bullet extends Weapon
{
  PVector originCell;
  PVector cellPosition;
  PVector positionOffset;
  PVector forward;
  float fieldRadius;
  float radius;
  int lastTrail;
  ArrayList<Trail> trail = new ArrayList<Trail>();
  
  Bullet(float x, float y, color colour, float speed, float damage)
  {
    super(x, y, colour, speed, damage);
    cellPosition = new PVector(x, y);
    originCell = new PVector(x, y);
    positionOffset = new PVector(0, 0);
    forward = new PVector(0, 0);
    radius = 10;
    lastTrail = 0;
  }
  Bullet()
  {
    super(0, 0, color(random(0, 255), random(0, 255), random(0, 255)), 0.1, 10);
  }
  
  public void setRadius(float r)
  {
    radius = r;
  }
  
  public void render()
  {
    // Calculate the coordinates
    position.x = border.get("left") + cellSize / 2 + (cellPosition.x + positionOffset.x) * cellSize + forward.x;
    position.y = border.get("top") + cellSize / 2 + (cellPosition.y - startCell + positionOffset.y) * cellSize + offset + forward.y;
    //stroke(0);
    noStroke();
    fill(colour);
    ellipse(position.x, position.y, radius, radius);
  }
  public void update()
  {
    forward.sub(direction);
    
    if (millis() - lastTrail > 10)
    {
      lastTrail = millis();
      
      if (trail.size() < 5)
      {
        trail.add(new Trail(cellPosition.x, cellPosition.y, positionOffset.x, positionOffset.y, forward.x, forward.y, radius, color(255, 0, 0, 50)));
      }
      else
      {
        trail.remove(0);
        trail.add(new Trail(cellPosition.x, cellPosition.y, positionOffset.x, positionOffset.y, forward.x, forward.y, radius, color(255, 0, 0, 50)));
      }
    }
    
    for (int i = 0 ; i < trail.size() ; i++)
    {
      trail.get(i).update();
      trail.get(i).render();
    }
  }
}