public class Destroyed extends GameObject 
{
  PVector cellPosition;
  PVector shapeOffset;
  float radius;
  int startTime;
  
  Destroyed(float x, float y, float xOffset, float yOffset, float radius, color colour)
  {
    cellPosition = new PVector(x, y);
    shapeOffset = new PVector(xOffset, yOffset);
    this.radius = radius;
    this.colour = colour;
    startTime = millis();
  }
  Destroyed(float x, float y, float xOffset, float yOffset, float radius)
  {
    this(x, y, xOffset, yOffset, radius, color(0));
  }
  Destroyed()
  {
    this(0, 0, 0, 0, 0, color(0));
  }
    
  void render()
  {
    // Calculate the coordinates of the object
    position.x = border.get("left") + cellSize / 2 + (cellPosition.x + shapeOffset.x) * cellSize;
    position.y = border.get("top") + cellSize / 2 + (cellPosition.y - startCell + shapeOffset.y) * cellSize + offset;
    
    // Draw the animation
    stroke(colour);
    fill(colour);
    ellipse(position.x, position.y, radius * 2, radius * 2);
    
    //println(cellPosition.x + " " + cellPosition.y);
  }
  
  void update()
  {
    if (millis() - startTime > 1000)
      destroyed.remove(this);
  }
}