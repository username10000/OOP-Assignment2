public class Enemy extends GameObject
{
  int edges;
  int life;
  int road;
  float radius;
  float speed;
  PShape polygon;
  PVector cellPosition;
  PVector direction;
  PVector shapeOffset;
  
  Enemy(int edges, int life, color colour, int road)
  {
    super(500, 500, colour);
    this.edges = edges;
    this.life = life;
    radius = map(edges, 5, 10, cellSize / 4, cellSize / 2);
    speed = 0.05;
    drawShape();
    this.road = road;
    cellPosition = getStart(road);
    direction = getDirection();
    shapeOffset = new PVector(0, 0);
  }
  Enemy()
  {
    this(5, 50, color(0, 0, 0), 1);
  }
  
  private void drawShape()
  { 
    // Create the shape and assign its colour
    polygon = createShape();
    polygon.beginShape();
    polygon.stroke(colour);
    polygon.fill(colour);
    for (int i = 0 ; i < edges ; i++)
    {
      float theta = i * (TWO_PI / edges);
      
      float x = sin(theta) * radius;
      float y = - cos(theta) * radius;
      
      polygon.vertex(x, y);
    }
    polygon.endShape(CLOSE);
  }
  private PVector getStart(int road)
  {
    // Get the position where a road starts
    PVector startPos = new PVector(0, 0);
    
    for (int i = 1 ; i < maps[curMap].cellsPerLine - 1 ; i++)
    {
      if (maps[curMap].map[0][i] == road)
      {
        startPos.x = i;
        startPos.y = 0;
        break;
      }
    }
    for (int j = 1 ; j <= maps[curMap].cellsPerCol / 2 && startPos.x == 0; j++)
    {
      if (maps[curMap].map[j][0] == road)
      {
        startPos.x = 0;
        startPos.y = j;
        break;
      }
      if (maps[curMap].map[j][maps[curMap].cellsPerLine - 1] == road)
      {
        startPos.x = maps[curMap].cellsPerLine - 1;
        startPos.y = j;
        break;
      }
    }
    return startPos;
  }
  private PVector getDirection()
  {
    PVector dir = new PVector(0, 1);
    if (cellPosition.x == 0)
    {
      dir = new PVector(1, 0);
    }
    if (cellPosition.x == maps[curMap].cellsPerLine - 1)
    {
      dir = new PVector (-1, 0);
    }
    return dir;
  }
  private int getValue(int x, int y)
  {
    if (x >= 0 && x < maps[curMap].cellsPerLine && y >= 0 && y < maps[curMap].cellsPerCol)
    {
      return maps[curMap].map[y][x];
    }
    else
    {
      return 0;
    }
  }
  private void updateDirection()
  { 
    PVector tempDirection;
    
    if (direction.x == 0)
    {
      tempDirection = new PVector(direction.y, 0);
    }
    else
    {
      tempDirection = new PVector(0, (-1) * direction.x);
    }
    
    // Change the direction of the enemy
    if (getValue((int)cellPosition.x + (int)tempDirection.x, (int)cellPosition.y + (int)tempDirection.y) >= 1)
    {
      // Left
      if (direction.x == 0)
      {
        direction.x = direction.y;
        direction.y = 0;
      }
      else
      {
        direction.y = (-1) * direction.x;
        direction.x = 0;
      }
    }
    else
    {
      // Right
      if (direction.x == 0)
      {
        direction.x = (-1) * direction.y;
        direction.y = 0;
      }
      else
      {
        direction.y = direction.x;
        direction.x = 0;
      } 
    }
  }
  public void render()
  {
    // Render the enemy
    if (position.x > border.get("left") && position.x < width - border.get("right") && position.y + radius > border.get("top") && position.y - radius < height - border.get("bottom"))
    {
      pushMatrix();
      
      translate(position.x, position.y);
      polygon.rotate(0.01);
      shape(polygon);
      
      popMatrix();
    }
  }
  public void update()
  {
    // Find the next direction
    if (getValue((int)cellPosition.x + (int)direction.x, (int)cellPosition.y + (int)direction.y) == 10)
    {
      for (int i = 0 ; i < objects.size() ; i++)
      {
        Enemy enemy = (Enemy)objects.get(i);
        if (enemy.cellPosition.x == cellPosition.x && enemy.cellPosition.y == cellPosition.y)
        {
          objects.remove(i);
          break;
        }
      }
    }
    if (getValue((int)cellPosition.x + (int)direction.x, (int)cellPosition.y + (int)direction.y) == 0)
    {
      updateDirection();
    }

    // Update the location of the enemy
    shapeOffset.add(PVector.mult(direction, speed));
    if (shapeOffset.x > 1 || shapeOffset.x < -1)
    {
      cellPosition.x += (int)shapeOffset.x;
      shapeOffset.x = 0;
    }
    if (shapeOffset.y > 1 || shapeOffset.y < -1)
    {
      cellPosition.y += (int)shapeOffset.y;
      shapeOffset.y = 0;
    }
    
    //cellPosition.add(PVector.mult(direction, speed));
    position.x = border.get("left") + cellSize / 2 + (cellPosition.x + shapeOffset.x) * cellSize;
    position.y = border.get("top") + cellSize / 2 + (cellPosition.y - startCell + shapeOffset.y) * cellSize + offset;
  }
}