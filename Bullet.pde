public class Bullet extends Weapon
{
  PVector originCell;
  PVector cellPosition;
  PVector positionOffset;
  PVector forward;
  
  Bullet(float x, float y, color colour, float speed, float damage)
  {
    super(x, y, colour, speed, damage);
    cellPosition = new PVector(x, y);
    originCell = new PVector(x, y);
    positionOffset = new PVector(0, 0);
    forward = new PVector(0, 0);
  }
  Bullet()
  {
    super(0, 0, color(random(0, 255), random(0, 255), random(0, 255)), 0.1, 10);
  }
  
  public void render()
  {
    // Calculate the coordinates
    position.x = border.get("left") + cellSize / 2 + (cellPosition.x + positionOffset.x) * cellSize + forward.x;
    position.y = border.get("top") + cellSize / 2 + (cellPosition.y - startCell + positionOffset.y) * cellSize + offset + forward.y;
    //stroke(0);
    noStroke();
    fill(colour);
    ellipse(position.x, position.y, 10, 10);
  }
  public void update()
  {
    forward.sub(direction);
  }
}