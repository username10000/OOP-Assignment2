public class Tower extends GameObject
{
  int type;
  int lastFired;
  float speed;
  float damage;
  boolean hover;
  color colour;
  PShape towerShape;
  PVector cellPosition;
  
  Tower(int type, int x, int y)
  {
    this.type = type;
    setAttributes();
    cellPosition = new PVector(x, y);
    colour = color(random(0, 255), random(0, 255), random(0, 255));
    drawShape();
    lastFired = millis();
    hover = true;
  }
  Tower()
  {
    this(0, 0, 0);
  }
  
  private void setAttributes()
  {
    // First type of tower
    if (type == 0)
    {
      speed = 0.05;
      damage = 25;
    }
    // Second type of tower
    if (type == 1)
    {
      speed = 0;
      damage = 1;
    }
  }
  private void drawShape()
  {
    float halfSize = cellSize / 2 - (cellSize / 10);
    
    towerShape = createShape();
    towerShape.beginShape();
    towerShape.stroke(colour);
    towerShape.fill(colour);
    towerShape.vertex(0, - halfSize);
    towerShape.vertex(- halfSize, halfSize);
    towerShape.vertex(halfSize, halfSize);
    towerShape.endShape(CLOSE);
  }
  public void render()
  {
    // Render the tower
    if (cellPosition.y >= startCell && cellPosition.y <= endCell)
    {
      // Calculate the coordinates of the enemy
      position.x = border.get("left") + cellSize / 2 + cellPosition.x * cellSize;
      position.y = border.get("top") + cellSize / 2 + (cellPosition.y - startCell) * cellSize + offset;
      
      if (hover)
      {
        strokeWeight(2);
        stroke(0, 0, 255, 200);
        fill(0, 255, 255, 100);
        ellipse(position.x, position.y, cellSize * 3, cellSize * 3);
        strokeWeight(1);
      }
      
      // Draw the tower
      pushMatrix();
      translate(position.x, position.y);
      shape(towerShape);
      popMatrix();
    }
  }
  public void update()
  {
    // Find if there is an enemy nearby and if there is fire at it
    if (millis() > lastFired + 1000)
    {
      for (int i = 0 ; i < objects.size() ; i++)
      {
        if (objects.get(i) instanceof Enemy && dist(objects.get(i).position.x, objects.get(i).position.y, position.x, position.y) < cellSize + cellSize / 2)
        {
          float lengthY = position.y - objects.get(i).position.y;
          float lengthX = position.x - objects.get(i).position.x;
          Bullet bullet = new Bullet(cellPosition.x, cellPosition.y, colour, 0.2, damage);
          bullet.direction = new PVector(lengthX / 15, lengthY / 15);
          weapons.add(bullet);
          break;
        }
      }
      lastFired = millis();
    }
  }
}