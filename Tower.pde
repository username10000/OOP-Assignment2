public class Tower extends GameObject
{
  //int type;
  int lastFired;
  int type;
  int[] upgradeLevel;
  float speed;
  float damage;
  float fieldRadius;
  boolean hover;
  boolean created;
  color colour;
  PShape towerShape;
  PVector cellPosition;
  AudioPlayer audio;

  Tower(int x, int y)
  {
    //this.type = type;
    //setAttributes();
    cellPosition = new PVector(x, y);
    //drawShape();
    lastFired = millis();
    hover = true;
    created = false;
    fieldRadius = 2 * cellSize + cellSize / 2;
    upgradeLevel = new int[3];
    upgradeLevel[0] = 0;
    upgradeLevel[1] = 0;
    upgradeLevel[2] = 0;
  }
  Tower()
  {
    this(0, 0);
  }
  
  protected void drawShape()
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
    if (cellPosition.y >= startCell - 1 && cellPosition.y <= endCell)
    {
      // Calculate the coordinates of the tower
      position.x = border.get("left") + cellSize / 2 + cellPosition.x * cellSize;
      position.y = border.get("top") + cellSize / 2 + (cellPosition.y - startCell) * cellSize + offset;
      
      if (hover)
      {
        strokeWeight(2);
        stroke(0, 0, 255, 200);
        fill(0, 255, 255, 100);
        ellipse(position.x, position.y, fieldRadius * 2, fieldRadius * 2);
        strokeWeight(1);
        
        textAlign(CENTER, CENTER);
        fill(0);
        textSize(10);
        text("DMG: Level " + upgradeLevel[0], position.x, position.y + cellSize / 2);
        text("SPD: Level " + upgradeLevel[1], position.x, position.y + cellSize / 2 + 10);
        text("RNG: Level " + upgradeLevel[2], position.x, position.y + cellSize / 2 + 20);
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
    /*
    switch(type)
    {
      case 0:
      {
        // Find if there is an enemy nearby and if there is fire at it
        if (millis() > lastFired + 1000)
        {
          for (int i = 0 ; i < objects.size() ; i++)
          {
            if (objects.get(i) instanceof Enemy && dist(objects.get(i).position.x, objects.get(i).position.y, position.x, position.y) < 2 * cellSize + cellSize / 2)
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
        break;
      }
      case 1:
      {
        // Create the ray
        if (!created)
        {
          Ray ray = new Ray(cellPosition.x, cellPosition.y, color(255), speed, damage);
          ray.isAlive = false;
          weapons.add(ray);
          created = true;
        }
        break;
      }
      case 2:
      {
        // Create the field
        if (!created)
        {
          Field field = new Field(cellPosition.x, cellPosition.y, colour, speed, damage);
          weapons.add(field);
          created = true;
        }
        break;
      }
    }
    */
  }
}