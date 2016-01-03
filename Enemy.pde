public class Enemy extends GameObject
{
  int edges;
  int life;
  int road;
  float radius;
  float speed;
  boolean wait;
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
    wait = false;
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
  private int getValue(float x, float y)
  {
    if (x >= 0 && x < maps[curMap].cellsPerLine && y >= 0 && y < maps[curMap].cellsPerCol)
    {
      return maps[curMap].map[(int)y][(int)x];
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
    if (getValue((int)cellPosition.x + (int)tempDirection.x, (int)cellPosition.y + (int)tempDirection.y) >= 1)// && checkDirection(PVector.add(cellPosition, tempDirection), tempDirection))
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
    
    // *************************************************************************
    // Another if to check if there are multiple paths where the enemy should go
    
    // Crash - maybe out of bounds?
    if (getValue((int)cellLeft.x, (int)cellLeft.y) == getValue((int)cellRight.x, (int)cellRight.y) && getValue((int)cellLeft.x, (int)cellLeft.y) != 0)
      return sameRoadDirection(cell, dirLeft, dirRight);
    if (getValue((int)cellLeft.x, (int)cellLeft.y) == getValue((int)cell.x + (int)dir.x, (int)cell.y + (int)dir.y) && getValue((int)cellLeft.x, (int)cellLeft.y) != 0)
      return sameRoadDirection(cell, dirLeft, dir);
    if (getValue((int)cellRight.x, (int)cellRight.y) == getValue((int)cell.x + (int)dir.x, (int)cell.y + (int)dir.y) && getValue((int)cellRight.x, (int)cellRight.y) != 0)
      return sameRoadDirection(cell, dirRight, dir);

    if (getValue((int)cellLeft.x, (int)cellLeft.y) <= getValue((int)cell.x, (int)cell.y) && getValue((int)cellLeft.x, (int)cellLeft.y) != 0)
      return dirLeft;
    if (getValue((int)cellRight.x, (int)cellRight.y) <= getValue((int)cell.x, (int)cell.y) && getValue((int)cellRight.x, (int)cellRight.y) != 0)
      return dirRight;
    return dir;
    /*
    // Still not working
    PVector cellLeft, cellRight, cellStraight;
    PVector dirLeft, dirRight, dirStraight;
    boolean l = false, r = false, s = true;
    
    if (cell.y == maps[curMap].cellsPerCol - 2)
      return true;
    if (cell.y == 0 || cell.x == 0 || cell.x == maps[curMap].cellsPerLine - 1)
      return false;
      
    // Straight
    cellStraight = new PVector(cell.x, cell.y);
    dirStraight = new PVector(dir.x, dir.y);
    
    do
    {
      // Left & Right
      if (dirStraight.x == 0)
      {
        dirLeft = new PVector(dirStraight.y, 0);
        dirRight = new PVector((-1) * dirStraight.y, 0);
      }
      else
      {
        dirLeft = new PVector(0, (-1) * dirStraight.x);
        dirRight = new PVector(0, dirStraight.x);
      }
      cellLeft = new PVector(cellStraight.x + dirLeft.x, cellStraight.y + dirLeft.y);
      cellRight = new PVector(cellStraight.x + dirRight.x, cellStraight.y + dirRight.y);
      
      if (getValue((int)cellLeft.x, (int)cellLeft.y) >= 1)
        l = checkDirection(cellLeft, dirLeft);
      if (getValue((int)cellRight.x, (int)cellRight.y) >= 1)
        r = checkDirection(cellRight, dirRight);
      if (getValue((int)cellStraight.x + (int)dirStraight.x, (int)cellStraight.y + (int)dirStraight.y) >= 1)
      {
        cellStraight.x += dirStraight.x;
        cellStraight.y += dirStraight.y;
      }
      else
      {
        s = false;
      }
      
    } while(cell.y != maps[curMap].cellsPerCol - 2 || cell.y != 0 || cell.x != maps[curMap].cellsPerLine - 1 || cell.x != 0 || !l || !r || s);
    
    if (cell.y == maps[curMap].cellsPerCol - 2 || l || r)
      return true;
    else
      return false;
    */
    /*
    boolean left = false, right = false, straight = false;
    PVector tempCell;
    PVector tempDir;
    
    if (cell.y == maps[curMap].cellsPerCol - 2)
      return true;
    if (cell.x == 0 || cell.x == maps[curMap].cellsPerLine - 1 || cell.y == 0)
      return false;
      
    // Check Left
    if (dir.x == 0)
    {
      tempDir = new PVector(cell.y, 0);
    }
    else
    {
      tempDir = new PVector(0, (-1) * cell.x);
    }
    tempCell = new PVector(cell.x + tempDir.x, cell.y + tempDir.y);
    if (getValue((int)tempCell.x, (int)tempCell.y) >= 1)
      left = checkDirection(tempCell, tempDir);
    
    // Check Right
    if (dir.x == 0)
    {
      tempDir = new PVector((-1) * cell.y, 0);
    }
    else
    {
      tempDir = new PVector(0, cell.x);
    }
    tempCell = new PVector(cell.x + tempDir.x, cell.y + tempDir.y);
    if (getValue((int)tempCell.x, (int)tempCell.y) >= 1)
      right = checkDirection(tempCell, tempDir);
    
    // Check straight
    tempCell = new PVector(cell.x + dir.x, cell.y + dir.y);
    if (getValue((int)tempCell.x, (int)tempCell.y) >= 1)
      straight = checkDirection(tempCell, tempDir);
    
    // If one of these is true then return true else false
    if (left || right || straight)
      return true;
    else
      return false;
    */
  }
  private PVector sameRoadDirection(PVector cell, PVector dir1, PVector dir2)
  {
    // It doesn't work
    
    // Road is vertical
    if (dir1.y == 1 || dir2.y == -1)
      return dir1;
    if (dir2.y == 1 || dir1.y == -1)
      return dir2;
    
    // Road is horizontal
    int tempX = -1;
    for (int i = 0 ; i < cell.x ; i++) // maps[curMap].cellsPerLine
    {
      if (getValue(i, (int)cell.y + 1) == getValue((int)cell.x + (int)dir1.x, (int)cell.y + (int)dir1.y))
      {
        tempX = i;
        break;
      }
    }
    
    if (tempX == -1) // tempX < cell.x && 
      return dir1;
    else
      return dir2;
    
    /*
    PVector newDir;
    
    do
    {
      newDir = checkDirection(cell, dir1); 
    } while (newDir.y != 1 || newDir.y != -1 || cell.x + newDir.x == 0 || cell.x + newDir.x == maps[curMap].cellsPerLine - 1 || cell.y + newDir.y == 0 || cell.y + newDir.y == maps[curMap].cellsPerCol - 1);
    
    if (newDir.y == 1)
      return dir1;
    else
      return dir2;
    */
  }
  private boolean checkIntersection(PVector cell)
  {
    int count = 0;
    
    if (getValue((int)cell.x - 1, (int)cell.y) != 0)
      count ++;
    if (getValue((int)cell.x + 1, (int)cell.y) != 0)
      count ++;
    if (getValue((int)cell.x, (int)cell.y - 1) != 0)
      count ++;
    if (getValue((int)cell.x, (int)cell.y + 1) != 0)
      count ++;
      
    if (count > 2)
      return true;
    else
      return false;
  }
  private boolean checkCollision(PVector cell)
  {
    // Check if the enemies collide
    
    // If there is an intersection 
    // *** This part has problems
    if (shapeOffset.x == 0 && shapeOffset.y == 0 && checkIntersection(cell))
    {
      if (getValue(cell.x, cell.y) != getValue(cellPosition.x, cellPosition.y))
      {
        for (int i = 0 ; i < objects.size() ; i++)
        {
          if (objects.get(i) instanceof Enemy)
          {
            Enemy tempEnemy = (Enemy)objects.get(i);
            if (tempEnemy.cellPosition.x + tempEnemy.direction.x == cell.x && tempEnemy.cellPosition.y + tempEnemy.direction.y == cell.y && getValue(tempEnemy.cellPosition.x, tempEnemy.cellPosition.y) != getValue(cellPosition.x, cellPosition.y))
              return true;
            //if (PVector.add(cellPosition, direction) == cell)
            //if (tempEnemy.cellPosition.x == cell.x && tempEnemy.cellPosition.y == cell.y)// && tempEnemy.cellPosition.x != cellPosition.x && tempEnemy.cellPosition.y != cellPosition.y)
              //return true;
          }
        }
        //return true;
      }
      /*
      for (int i = 0 ; i < objects.size() ; i++)
      {
        if (objects.get(i) instanceof Enemy)
        {
          Enemy tempEnemy = (Enemy)objects.get(i);
          //if (PVector.add(cellPosition, direction) == cell)
          if (tempEnemy.cellPosition.x == cell.x && tempEnemy.cellPosition.y == cell.y)// && tempEnemy.cellPosition.x != cellPosition.x && tempEnemy.cellPosition.y != cellPosition.y)
            return true;
        }
      }
      */
    }
    else
    {
      // If there is a queue
      if (shapeOffset.x == 0 && shapeOffset.y == 0)
      {
        for (int i = 0 ; i < objects.size() ; i++)
        {
           if (objects.get(i) instanceof Enemy)
            {
              Enemy tempEnemy = (Enemy)objects.get(i);
              if (getValue(tempEnemy.cellPosition.x, tempEnemy.cellPosition.y) == getValue(cellPosition.x, cellPosition.y) && tempEnemy.cellPosition.x == cell.x && tempEnemy.cellPosition.y == cell.y && tempEnemy.wait)
              {
                return true;
              }
            }
        }
      }
    }
    return false;
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
  public void update() //<>//
  {
    // Find the next direction
    if (getValue((int)cellPosition.x + (int)direction.x, (int)cellPosition.y + (int)direction.y) == 10 || cellPosition.x < 0 || cellPosition.x > maps[curMap].cellsPerLine - 1 || cellPosition.y < 0)
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

    if (!checkCollision(PVector.add(cellPosition, direction)))
    {
      wait = false;
      // Update the location of the enemy
      shapeOffset.add(PVector.mult(direction, speed));
    }
    else
    {
      wait = true;
    }
    if (shapeOffset.x >= 1 || shapeOffset.x <= -1)
    {
      cellPosition.x += (int)direction.x;
      shapeOffset.x = 0;
      // Change direction if necessary
      direction = checkDirection(cellPosition, direction);
    }
    if (shapeOffset.y >= 1 || shapeOffset.y <= -1)
    {
      cellPosition.y += (int)direction.y;
      shapeOffset.y = 0;
      // Change direction if necessary
      direction = checkDirection(cellPosition, direction);
    }
    
    // Calculate the coordinates of the enemy
    position.x = border.get("left") + cellSize / 2 + (cellPosition.x + shapeOffset.x) * cellSize;
    position.y = border.get("top") + cellSize / 2 + (cellPosition.y - startCell + shapeOffset.y) * cellSize + offset;
  }
}