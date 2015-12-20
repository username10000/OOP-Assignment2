public class MapObject
{
  int[][] map;
  int cellsPerLine;
  int cellsPerCol;
  
  MapObject(String name)
  {
    importMap(name);
  }
  MapObject()
  {
    randomMap();
  }
  
  private boolean checkAround(PVector pos, int roadNo)
  {
    // Check the next position to verify if there are any roads around it
    int count = 0;
    
    if (map[(int)pos.y - 1][(int)pos.x] == roadNo)
      count ++;
    if (map[(int)pos.y + 1][(int)pos.x] == roadNo)
      count ++;
    if (map[(int)pos.y][(int)pos.x - 1] == roadNo)
      count ++;
    if (map[(int)pos.y][(int)pos.x + 1] == roadNo)
      count ++;
    
    if (count <= 1)
      return true;
    else
      return false;
  }
  
  private boolean checkConnection(PVector pos, int roadNo)
  {
    // Check if there is another road around that this road has intersected
    int count = 0;
    
    if (map[(int)pos.y - 1][(int)pos.x] != roadNo && map[(int)pos.y - 1][(int)pos.x] != 0)
      count ++;
    if (map[(int)pos.y + 1][(int)pos.x] != roadNo && map[(int)pos.y + 1][(int)pos.x] != 0)
      count ++;
    if (map[(int)pos.y][(int)pos.x - 1] != roadNo && map[(int)pos.y][(int)pos.x - 1] != 0)
      count ++;
    if (map[(int)pos.y][(int)pos.x + 1] != roadNo && map[(int)pos.y][(int)pos.x + 1] != 0)
      count ++;
      
    if (count > 0)
      return true;
    else
      return false;
  }
  
  public void randomMap()
  {
    // Get a random odd value for the number of columns
    cellsPerLine = (int)random(30, 40);
    if (cellsPerLine % 2 == 0)
    {
      cellsPerLine --;
    }
    
    // Get a random odd value for the number of lines
    cellsPerCol = (int)random(cellsPerLine + 1, cellsPerLine + 10);
    if (cellsPerCol % 2 == 0)
    {
      cellsPerCol --;
    }
    
    // Allocate enough space for the 2D array
    map = new int[cellsPerCol][cellsPerLine];
    
    // Add the the destination
    for (int i = 0 ; i < cellsPerLine ; i++)
    {
      map[cellsPerCol - 1][i] = 10;
    }
    
    int numRoads = 9;
    
    for (int i = 1 ; i <= numRoads ; i++)
    {
      PVector curRoad;
      PVector direction;
      switch((int)random(0, 3))
      {
        case 0:
        {
          // Start from top
          curRoad = new PVector((int)random(1, cellsPerLine - 2), 0);
          direction = new PVector(0, 1);
          
          while (map[(int)curRoad.y][(int)curRoad.x - 1] != 0 || map[(int)curRoad.y][(int)curRoad.x + 1] != 0 || map[(int)curRoad.y][(int)curRoad.x] != 0)
          {
            curRoad.x = (int)random(1, cellsPerLine - 2);
          }
          
          break;
        }
        case 1:
        {
          // Start from left
          curRoad = new PVector(0, (int)random(1, cellsPerCol / 2));
          direction = new PVector(1, 0);
          
          while (map[(int)curRoad.y - 1][(int)curRoad.x] != 0 || map[(int)curRoad.y + 1][(int)curRoad.x] != 0 || map[(int)curRoad.y][(int)curRoad.x] != 0)
          {
            curRoad.y = (int)random(1, cellsPerCol / 2);
          }
          
          break;
        }
        default:
        {
          // Start from right
          curRoad = new PVector(cellsPerLine - 1, (int)random(1, cellsPerCol / 2));
          direction = new PVector(-1, 0);
          
          while (map[(int)curRoad.y - 1][(int)curRoad.x] != 0 || map[(int)curRoad.y + 1][(int)curRoad.x] != 0 || map[(int)curRoad.y][(int)curRoad.x] != 0)
          {
            curRoad.y = (int)random(1, cellsPerCol / 2);
          }
                  
          break;
        }
      }
      
      // Add the first element
      map[(int)curRoad.y][(int)curRoad.x] = i;
      curRoad.add(direction);
      
      // Make a random road until it reached the destination
      while (curRoad.y != cellsPerCol - 2 && !checkConnection(curRoad, i))
      {
        // Add the current road to the map
        map[(int)curRoad.y][(int)curRoad.x] = i;
        
        // Change the direction
        switch((int)random(0, 3))
        {
          case 0:
          {
            // Left
            float temp = direction.x;
            direction.x = (-1) * direction.y;
            direction.y = (-1) * temp;
            break;
          }
          case 1:
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
            break;
          }
          default:
          {
            // Straight
            break;
          }
        }
        
        // Go in that direction if possible
        curRoad.add(direction);
        if ((int)curRoad.x == 0 || (int)curRoad.x == cellsPerLine - 1 || (int)curRoad.y == 0 || (int)curRoad.y == cellsPerCol - 1 || direction.y == -1)
        {
            curRoad.sub(direction);
        }
        else 
        {
          if (!checkAround(curRoad, i))
            curRoad.sub(direction);
        }
      }
      
      // Add the final part of the road
      map[(int)curRoad.y][(int)curRoad.x] = i;
    }
  }
  
  public void importMap(String fileName)
  {
    // Read the file
    String[] lines = loadStrings(fileName);
    
    // Calculate the cells per line and per column
    cellsPerLine = lines[0].length();
    cellsPerCol = lines.length;
    
    // Allocate enough space for the 2D array
    map = new int[cellsPerCol][cellsPerLine];
    
    // Get the 2D array
    for (int i = 0 ; i < cellsPerCol ; i++)
    {
      for (int j = 0 ; j < cellsPerLine ; j++)
      {
        if (lines[i].charAt(j) == '1')
        {
          map[i][j] = 1;
        }
        else
        {
          map[i][j] = 0;
        }
        //print(map[i][j] + " ");
      }
      //println();
    }
  }
}