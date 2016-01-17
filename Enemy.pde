public class Enemy extends GameObject
{
  int edges;
  int health;
  int road;
  float radius;
  float speed;
  PShape polygon;
  PVector cellPosition;
  PVector previousCell;
  PVector shapeOffset;
  
  Enemy(int edges, color colour, int road)
  {
    super(500, 500, colour);
    this.edges = edges;
    health = 50 * edges;
    radius = map(edges, 5, 10, cellSize / 4, cellSize / 2);
    speed = 0.012;
    drawShape();
    this.road = road;
    cellPosition = getStart(road);
    direction = getDirection();
    cellPosition.x -= direction.x;
    cellPosition.y -= direction.y;
    shapeOffset = new PVector(0, 0);
    previousCell = new PVector(cellPosition.x, cellPosition.y);
  }
  Enemy()
  {
    this(5, color(0, 0, 0), 1);
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
      if (maps[curMap].map[0][i] == (char)(road + '0'))
      {
        startPos.x = i;
        startPos.y = 0;
        break;
      }
    }
    for (int j = 1 ; j <= maps[curMap].cellsPerCol / 2 && startPos.x == 0; j++)
    {
      if (maps[curMap].map[j][0] == (char)(road + '0'))
      {
        startPos.x = 0;
        startPos.y = j;
        break;
      }
      if (maps[curMap].map[j][maps[curMap].cellsPerLine - 1] == (char)(road + '0'))
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
  private char getValue(float x, float y)
  {
    if (x >= 0 && x < maps[curMap].cellsPerLine && y >= 0 && y < maps[curMap].cellsPerCol)
    {
      return maps[curMap].map[(int)y][(int)x];
    }
    else
    {
      return '0';
    }
  }
  private PVector checkDirection(PVector cell, PVector dir)
  {
    PVector cellLeft, cellRight;
    PVector dirLeft, dirRight;
    if (dir.x == 0)
    {
      dirLeft = new PVector(dir.y, 0);
      dirRight = new PVector((-1) * dir.y, 0);
    }
    else
    {
      dirLeft = new PVector(0, (-1) * dir.x);
      dirRight = new PVector(0, dir.x);
    }
    cellLeft = new PVector(cell.x + dirLeft.x, cell.y + dirLeft.y);
    cellRight = new PVector(cell.x + dirRight.x, cell.y + dirRight.y);
    
    // Check if it's the same road to the left and to the right
    if (getValue((int)cellLeft.x, (int)cellLeft.y) == getValue((int)cellRight.x, (int)cellRight.y) && getValue((int)cellLeft.x, (int)cellLeft.y) != '0')
      return sameRoadDirection(cell, dirLeft, dirRight);
    // Check if it's the same road to the left and straight
    if (getValue((int)cellLeft.x, (int)cellLeft.y) == getValue((int)cell.x + (int)dir.x, (int)cell.y + (int)dir.y) && getValue((int)cellLeft.x, (int)cellLeft.y) != '0')
      return sameRoadDirection(cell, dirLeft, dir);
    // Check if it's the same road to the right and straight
    if (getValue((int)cellRight.x, (int)cellRight.y) == getValue((int)cell.x + (int)dir.x, (int)cell.y + (int)dir.y) && getValue((int)cellRight.x, (int)cellRight.y) != '0')
      return sameRoadDirection(cell, dirRight, dir);

    // The next if statements check where the smallest number road goes. It does this because the smallest numbers are generated first so the path to the finish must end with them.
    
    // Go to left if it's smaller
    if (getValue((int)cellLeft.x, (int)cellLeft.y) <= getValue((int)cell.x, (int)cell.y) && getValue((int)cellLeft.x, (int)cellLeft.y) != '0')
      return dirLeft;
    // Go to right if it's smaller
    if (getValue((int)cellRight.x, (int)cellRight.y) <= getValue((int)cell.x, (int)cell.y) && getValue((int)cellRight.x, (int)cellRight.y) != '0')
      return dirRight;
    // Go straight otherwise
    return dir;
  }
  private PVector sameRoadDirection(PVector cell, PVector dir1, PVector dir2)
  {
    // Road is vertical
    if (dir1.y == 1 || dir2.y == -1)
      return dir1;
    if (dir2.y == 1 || dir1.y == -1)
      return dir2;
    
    // Road is horizontal
    int tempUp = -1;
    int tempDown = -1;
    for (int i = 0 ; i < maps[curMap].cellsPerLine && (tempUp == -1 || tempDown == -1); i++)
    {
      if (getValue(i, (int)cell.y - 1) == getValue((int)cell.x, (int)cell.y) && tempUp == -1)
      {
        tempUp = i;
      }
      if (getValue(i, (int)cell.y + 1) == getValue((int)cell.x, (int)cell.y) && tempDown == -1)
      {
        tempDown = i;
      }
    }
    
    // Check if the upper row or the lower row doesn't have the current road
    if (tempDown == -1 || tempUp == -1)
    {
      // Check if the lower row doesn't have the current road
      if (tempDown == -1)
      {
        // Check the upper row road position
        if (tempUp < cell.x)
          return dir1;
        else
          return dir2;
      }
      else
      {
        // Check the lower row road position
        if (tempDown > cell.x)
          return dir1;
        else
          return dir2;
      }
    }
    else
    {
      // If neither the upper or lower road is -1 then check the position of one of them and return the corrent direction
      if (tempDown > cell.x)
        return dir1;
      else
        return dir2;
    }
    
    // The old way of doing it. This works 95% of the time.
    /*
    int tempX = -1;
    for (int i = 0 ; i < cell.x ; i++) // maps[curMap].cellsPerLine
    {
      if (getValue(i, (int)cell.y + 1) == getValue((int)cell.x, (int)cell.y))
      {
        tempX = i;
        break;
      }
    }
    
    if (tempX == -1) // tempX < cell.x && 
      return dir1;
    else
      return dir2;
    */
  }
  public void render()
  { 
    // Calculate the coordinates of the enemy
    position.x = border.get("left") + cellSize / 2 + (cellPosition.x + shapeOffset.x) * cellSize;
    position.y = border.get("top") + cellSize / 2 + (cellPosition.y - startCell + shapeOffset.y) * cellSize + offset;
    
    // Render the enemy
    if (position.x > border.get("left") && position.x < width - border.get("right") && position.y + radius > border.get("top") && position.y - radius < height - border.get("bottom"))
    {
      pushMatrix();
      
      translate(position.x, position.y);
      polygon.rotate(0.01);
      shape(polygon);
      
      popMatrix();
      
      textAlign(CENTER, CENTER);
      textSize(10);
      fill(0);
      text(health + "/" + 50 * edges, position.x, position.y);
    }
  }
  public void update() //<>//
  {
    if (health <= 0)
      isAlive = false;
    // Find the next direction
    if (getValue((int)cellPosition.x + (int)direction.x, (int)cellPosition.y + (int)direction.y) == '*' || cellPosition.x < -1 || cellPosition.x > maps[curMap].cellsPerLine || cellPosition.y < -1)
    {
      // Decrement the player's lives
      if (getValue((int)cellPosition.x + (int)direction.x, (int)cellPosition.y + (int)direction.y) == '*' && player.lives > 0)
      {
        player.lives --;
      }
      
      // Delete the enemy from the objects arraylist
      for (int i = 0 ; i < objects.size() ; i++)
      {
        if (objects.get(i) instanceof Enemy)
        {
          Enemy enemy = (Enemy)objects.get(i);
          if (enemy.cellPosition.x == cellPosition.x && enemy.cellPosition.y == cellPosition.y)
          {
            objects.remove(i);
            break;
          }
        }
      }
    }
    
    // Update the location of the enemy
    shapeOffset.add(PVector.mult(direction, speed));
    if (shapeOffset.x >= 1 || shapeOffset.x <= -1)
    {
      // Move the cell position and reset the offset
      previousCell.x = cellPosition.x;
      cellPosition.x += (int)direction.x;
      shapeOffset.x = 0;
      shapeOffset.y = 0;
      
      // Change direction if necessary
      direction = checkDirection(cellPosition, direction);
    }
    if (shapeOffset.y >= 1 || shapeOffset.y <= -1)
    {
      // Move the cell position and reset the offset
      previousCell.y = cellPosition.y;
      cellPosition.y += (int)direction.y;
      shapeOffset.y = 0;
      shapeOffset.x = 0;
      
      // Change direction if necessary
      direction = checkDirection(cellPosition, direction);
    }
  }
}