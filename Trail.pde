public class Trail extends GameObject
{
  PVector cellPosition;
  PVector positionOffset;
  PVector forward;
  float radius;
  
  Trail(float cx, float cy, float ox, float oy, float fx, float fy, float radius, color colour)
  {
    cellPosition = new PVector(cx, cy);
    positionOffset = new PVector(ox, oy);
    forward = new PVector(fx, fy);
    this.radius = radius;
    this.colour = colour;
  }
  
  public void render()
  {
    position.x = border.get("left") + cellSize / 2 + (cellPosition.x + positionOffset.x) * cellSize + forward.x;
    position.y = border.get("top") + cellSize / 2 + (cellPosition.y - startCell + positionOffset.y) * cellSize + offset + forward.y;
    
    noStroke();
    fill(colour);
    ellipse(position.x, position.y, radius, radius);
  }
  
  public void update()
  {
  }
}