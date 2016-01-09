import java.util.Hashtable;
import java.util.Map;

int cellsPerHeight;
int startCell, endCell;
//int lastCheck = millis();
int curMap = 8;
int[] noEnemies = new int[9];
float screenSize;
float gap;
float screenWidth, screenHeight;
float cellSize;
float offset;
Map<String, Float> border = new HashMap<String, Float>();
PVector mousePosition = new PVector(-1, -1, -1);
MapObject[] maps = new MapObject[9];
MapObject importMap;
ArrayList<GameObject> objects = new ArrayList<GameObject>();
PImage background;
//Enemy enemy;

void setup()
{
  //size(displayWidth, displayHeight);
  fullScreen();
  background(0);
  stroke(255);
  textAlign(CENTER);
  //randomSeed((int)random(5000));
  //randomSeed(5000);
  
  // Change the size of the screen
  //surface.setSize(displayWidth / 2, displayHeight / 2);
  
  // Import a map from a file
  //importMap = new MapObject("map.txt");
  
  // Random maps
  for (int i = 0 ; i < maps.length ; i++)
  {
    maps[i] = new MapObject(i + 1);
  }
  
  //maps[8] = new MapObject("map.txt");
  
  // Output current array
  /*
  String[] output = new String[maps[curMap].map.length];
  for (int i = 0 ; i < maps[curMap].map.length ; i++)
  {
    for (int j = 0 ; j <maps[curMap].map[i].length ; j++)
    {
      if (j == 0)
        output[i] = "" + maps[curMap].map[i][j];
      else
        output[i] = output[i] + maps[curMap].map[i][j];
    }
  }
  saveStrings("array.txt", output);
  */
  
  // Initial Settings
  initialSettings();

  // New Enemy
  //createEnemy(1);
  for (int i = 0 ; i < noEnemies.length ; i++)
  {
    noEnemies[i] = (int)random(10, 15);
  }
  
  //createMapImage();
}

void draw()
{
  background(0);
  
  // Draw the borders of the screen
  //noFill();
  fill(0, 92, 9);
  noStroke();
  //stroke(255);
  rect(border.get("left"), border.get("top"), screenWidth, screenHeight);
  
  // Only for debugging
  /*
  for (int i = 0 ; i <= cellsPerLine ; i++)
  {
    // Vertical Lines
    line(border.get("left") + cellSize * i, border.get("top"), border.get("left") + cellSize * i, border.get("top") + screenHeight);
  }
  for (int i = 0 ; i <= cellsPerHeight ; i++)
  {
    // Horizontal Lines
    line(border.get("left"), border.get("top") + cellSize * i, border.get("left") + screenWidth, border.get("top") + cellSize * i);
  }*/
  
  // Draw the occupied cells
  drawRoad();
  
  // Mark the cell if it's hovered
  if (mousePosition.z == 0)
  {
    // Change the colour of the selected cell depending if it's a valid position
    if (maps[curMap].map[(int)mousePosition.y + startCell][(int)mousePosition.x] >= '1' && maps[curMap].map[(int)mousePosition.y + startCell][(int)mousePosition.x] <= '9' || maps[curMap].map[(int)mousePosition.y + startCell][(int)mousePosition.x] == '*')
    {
      stroke(255, 0, 0);
      fill(255, 0, 0, 100);
    }
    else
    {
      stroke(0, 255, 0);
      fill(0, 255, 0, 100);
    }
    rect(border.get("left") + mousePosition.x * cellSize, border.get("top") + mousePosition.y * cellSize + offset, cellSize, cellSize);
  }
  
  // Do stuff if the cell is clicked on
  if (mousePosition.z == 1)
  {
    // Check if the clicked cell is a tower and do things
  }
  
  // Update enemies
  for (int i = 0 ; i < objects.size() ; i++)
  {
    objects.get(i).update();
  }
  
  // Render enemies
  for (int i = 0 ; i < objects.size() ; i++)
  {
    objects.get(i).render();
  }
  
  // Create enemies
  for (int i = 0 ; i < noEnemies.length ; i++)
  {
    if (noEnemies[i] > 0 && i <= curMap)
    {
      createEnemy(i + 1);
    }
  }
  
  // Draw all the information needed on the screen
  //drawInfo();
  
  // Check if the mouse is hovering something
  mouseHover();
  
  // Draw the rect border on top of the enemies
  //noFill();
  //stroke(255);
  //rect(border.get("left"), border.get("top"), screenWidth, screenHeight);

  // Combine enemies if they collide
  combineEnemies();
}

void initialSettings()
{
  // Set the borders
  border.put("top", map(0, 0, 100, 0, height));
  border.put("bottom", map(0, 0, 100, 0, height));
  border.put("left", map(0, 0, 100, 0, width));
  border.put("right", map(0, 0, 100, 0, width));
  
  // Calculate the screen width and height
  screenWidth = width - border.get("left") - border.get("right");
  screenHeight = height - border.get("top") - border.get("bottom");
  
  // Calculate the cell size
  cellSize = screenWidth / maps[curMap].cellsPerLine;
  
  // Calculate how many rows of cols can fit on the screen and change the screen height and bottom border to match
  cellsPerHeight = (int)(screenHeight / cellSize) + 1;
  // Special case if the cells fit perfectly
  if ((screenHeight / cellSize) - (int)(screenHeight / cellSize) == 0)
  {
    cellsPerHeight --;
  }
  screenHeight = cellSize * cellsPerHeight;
  border.put("bottom", height - screenHeight - border.get("top"));
  startCell = 0;
  endCell = cellsPerHeight;
}

void drawRoad()
{
  // Draw the occupied cells
  for (int i = 0 ; i < endCell - startCell ; i++)
  {
    for (int j = 0 ; j < maps[curMap].cellsPerLine ; j++)
    {
      if (maps[curMap].map[i + startCell][j] >= '1' && maps[curMap].map[i + startCell][j] <= '9')
      {
        fill(255);
        stroke(255);
        rect(border.get("left") + j * cellSize, border.get("top") + i * cellSize + offset, cellSize, cellSize);
      }
      if (maps[curMap].map[i + startCell][j] == '*')
      {
        fill(0, 255, 255);
        stroke(0, 255, 255);
        rect(border.get("left") + j * cellSize, border.get("top") + i * cellSize + offset, cellSize, cellSize);
      }
    }
  }
  
  if (offset < 0)
  {
    for (int j = 0 ; j < maps[curMap].cellsPerLine ; j++)
    {
      if (maps[curMap].map[endCell][j] >= '1' && maps[curMap].map[endCell][j] <= '9')
      {
        fill(255);
        stroke(255);
        rect(border.get("left") + j * cellSize, border.get("top") + (endCell - startCell) * cellSize + offset, cellSize, cellSize);
      }
      if (maps[curMap].map[endCell][j] == '*')
      {
        fill(0, 255, 255);
        stroke(0, 255, 255);
        rect(border.get("left") + j * cellSize, border.get("top") + (endCell - startCell) * cellSize + offset, cellSize, cellSize);
      }
    }
  }
  if (offset > 0)
  {
    for (int j = 0 ; j < maps[curMap].cellsPerLine ; j++)
    {
      if (maps[curMap].map[startCell - 1][j] >= '1' && maps[curMap].map[startCell - 1][j] <= '9')
      {
        fill(255);
        stroke(255);
        rect(border.get("left") + j * cellSize, border.get("top") + -1 * cellSize + offset, cellSize, cellSize);
      }
      if (maps[curMap].map[startCell - 1][j] == '*')
      {
        fill(0, 255, 255);
        stroke(0, 255, 255);
        rect(border.get("left") + j * cellSize, border.get("top") + -1 * cellSize + offset, cellSize, cellSize);
      }
    }
  }
}

void createMapImage()
{
  background = createImage((int)(maps[curMap].cellsPerLine * cellSize), (int)(maps[curMap].cellsPerCol * cellSize), RGB);
  
  for (int i = 0 ; i < (int)(maps[curMap].cellsPerCol * cellSize) ; i++)
  {
    for (int j = 0 ; j < (int)(maps[curMap].cellsPerLine * cellSize) ; j++)
    {
      background.pixels[i * width + j] = color(0, 255, 0);
    }
  }
  
  for (int i = 0 ; i < maps[curMap].cellsPerCol ; i++)
  {
    for (int j = 0 ; j < maps[curMap].cellsPerLine ; j++)
    {
      if (maps[curMap].map[i][j] >= '1' && maps[curMap].map[i][j] < '9')
      {
        for (int k = (int)(j * (int)cellSize); k <= j * cellSize + cellSize ; k++)
        {
          for (int l = (int)(i * (int)cellSize); l <= i * cellSize + cellSize ; l++)
          {
            background.pixels[l * width + k] = color(255, 255, 255);
          }
        }
      }
      if (maps[curMap].map[i][j] == '*')
      {
        for (int k = (int)(j * (int)cellSize); k <= j * cellSize + cellSize ; k++)
        {
          for (int l = (int)(i * (int)cellSize); l <= i * cellSize + cellSize ; l++)
          {
            background.pixels[l * width + k] = color(0, 255, 255);
          }
        }
      }
    }
  }
  
  background.save("background.jpg");
  
  /*
  // Draw the occupied cells
  for (int i = 0 ; i < endCell - startCell ; i++)
  {
    for (int j = 0 ; j < maps[curMap].cellsPerLine ; j++)
    {
      if (maps[curMap].map[i + startCell][j] >= 1 && maps[curMap].map[i + startCell][j] < 10)
      {
        fill(255);
        stroke(255);
        rect(border.get("left") + j * cellSize, border.get("top") + i * cellSize + offset, cellSize, cellSize);
      }
      if (maps[curMap].map[i + startCell][j] == 10)
      {
        fill(0, 255, 255);
        stroke(0, 255, 255);
        rect(border.get("left") + j * cellSize, border.get("top") + i * cellSize + offset, cellSize, cellSize);
      }
    }
  }
  */
}

void drawInfo()
{
  // Draw top and bottom border
  stroke(0);
  fill(0);
  rect(0, 0, width, border.get("top"));
  rect(0, height - border.get("bottom"), width, border.get("bottom"));
  
  // Draw the top and bottom arrows
  fill(255);
  textAlign(CENTER, BOTTOM);
}


void createEnemy(int road)
{
  // Assume the spawn point is empty
  boolean empty = true;
  
  // Check if the spawn point of the road is empty
  for (int i = 0 ; i < objects.size() ; i++)
  {
    if (objects.get(i) instanceof Enemy)
    {
      Enemy enemy = (Enemy)objects.get(i);
      if ((enemy.cellPosition.y == -1 || enemy.cellPosition.x == -1 || enemy.cellPosition.x == maps[curMap].cellsPerLine) && (enemy.road == road))
      {
        empty = false;
      }
    }
  }
  
  // If the spawn point is empty add a new enemy
  if (empty)
  {
    // Create a new enemy
    Enemy enemy = new Enemy(5, 50, color(random(0, 255), random(0, 255), random(0, 255)), road);
    objects.add(enemy);
    // Decrease the amount of enemies in that road
    noEnemies[road - 1] --;
  }
}

boolean checkOrigin(Enemy e1, Enemy e2)
{
  if (e1.previousCell.x == e2.previousCell.x && e1.previousCell.y == e2.previousCell.y)
    return true;
  else
    return false;
}

void combineEnemies()
{
  // Check if two enemies collide
  for (int i = 0 ; i < objects.size() ; i++)
  {
    for (int j = 0 ; j < objects.size() ; j++)
    {
      // Check if the object is an Enemy
      if (i != j && objects.get(i) instanceof Enemy && objects.get(j) instanceof Enemy && objects.get(i).isAlive && objects.get(j).isAlive)
      {
        Enemy e1 = (Enemy)objects.get(i);
        Enemy e2 = (Enemy)objects.get(j);
        
        // Check if they are in the same cell
        //if (e1.cellPosition.x == e2.cellPosition.x && e1.cellPosition.y == e2.cellPosition.y && !checkOrigin(e1, e2)) //  && e1.checkIntersection(e1.cellPosition)
        if (dist(e1.position.x, e1.position.y, e2.position.x, e2.position.y) <= e1.radius && !(e1.cellPosition.x == -1 || e1.cellPosition.x == maps[curMap].cellsPerLine || e1.cellPosition.y == -1))
        {
          // Increase the bigger cell
          if (e1.edges > e2.edges)
          {
            // Kill the smaller enemy
            e2.isAlive = false;
            
            // Limit the edges of the polygon to 10
            if (e1.edges < 10)
            {
              // Increase the size of the bigger polygon
              e1.edges ++;
              e1.radius = map(e1.edges, 5, 10, cellSize / 4, cellSize / 2);
              e1.drawShape();
            }
          }
          else
          {
            // Kill the smaller enemy
            e1.isAlive = false;
            
            // Limit the edges of the polygon to 10
            if (e2.edges < 10)
            {
              // Increase the size of the bigger polygon
              e2.edges ++;
              e2.radius = map(e2.edges, 5, 10, cellSize / 4, cellSize / 2);
              e2.drawShape();                
            }
            
            // Break the inner loop because the first enemy is dead so there is no need to check it
            break;
          }
        }
      }
    }
  }
  
  // Remove all enemies that are dead
  for (int i = 0 ; i < objects.size() ; i++)
  {
    if (!objects.get(i).isAlive)
    {
      objects.remove(i);
    }
  }
}

void mouseHover()
{ 
  // Mark the selected cell
  if (mouseX > border.get("left") && mouseX < width - border.get("right") && mouseY > border.get("top") && mouseY < height - border.get("bottom"))
  {
    mousePosition.x = (int)map(mouseX, border.get("left"), width - border.get("right"), 0, maps[curMap].cellsPerLine);
    mousePosition.y = (int)map(mouseY, border.get("top") + offset, height - border.get("bottom") + offset, 0, cellsPerHeight);
    mousePosition.z = 0;
  }
  else
  {
    mousePosition.x = -1;
    mousePosition.y = -1;
    mousePosition.z = -1;
  }
  
  // Move the screen up
  if (mouseY < border.get("top") || mouseY < cellSize)
  {
    if (startCell > 0)
    {
      offset += 10;
      if (offset > cellSize)
      {
        startCell --;
        endCell --;
        offset = 0;
      }
      mousePosition.z = -1;
    }
  }
  // Move the screen down
  if (mouseY > border.get("top") + screenHeight || mouseY > height - cellSize)
  {
    if (endCell < maps[curMap].cellsPerCol)
    {
      offset -= 10;
      if (offset < -cellSize)
      {
        startCell ++;
        endCell ++;
        offset = 0;
      }
      mousePosition.z = -1;
    }
  }
}

void keyPressed()
{
  if (key >= '1' && key <= '9')
  {
    curMap = key - '0' - 1;
    initialSettings();
  }
}

void mouseClicked()
{
  if (mousePosition.z == 0)
  {
    if (maps[curMap].map[(int)mousePosition.y][(int)mousePosition.x] == '0')
    {
      Tower tower = new Tower(0, startCell + (int)mousePosition.x, (int)mousePosition.y);
      objects.add(tower);
    }
  }
}