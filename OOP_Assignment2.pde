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
  
  //maps[0] = new MapObject("map.txt");
  
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
  saveStrings("array.txt", output);*/
  
  // Initial Settings
  initialSettings();

  // New Enemy
  //createEnemy(1);
  noEnemies[0] = 5;
  noEnemies[1] = 4;
  noEnemies[2] = 3;
}

void draw()
{
  background(0);
  
  // Draw the borders of the screen
  //noFill();
  fill(0, 92, 9);
  stroke(255);
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
    if (maps[curMap].map[(int)mousePosition.y + startCell][(int)mousePosition.x] >= 1)
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
  drawInfo();
  
  // Check if the mouse is hovering something
  mouseHover();
  
  // Draw the rect border on top of the enemies
  noFill();
  stroke(255);
  rect(border.get("left"), border.get("top"), screenWidth, screenHeight);
}

void initialSettings()
{
  // Set the borders
  border.put("top", map(3, 0, 100, 0, height));
  border.put("bottom", map(3, 0, 100, 0, height));
  border.put("left", map(0.1, 0, 100, 0, width));
  border.put("right", map(0.1, 0, 100, 0, width));
  
  // Calculate the screen width and height
  screenWidth = width - border.get("left") - border.get("right");
  screenHeight = height - border.get("top") - border.get("bottom");
  
  // Calculate the cell size
  cellSize = screenWidth / maps[curMap].cellsPerLine;
  
  // Calculate how many rows of cols can fit on the screen and change the screen height and bottom border to match
  cellsPerHeight = (int)(screenHeight / cellSize);
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
  
  if (offset < 0)
  {
    for (int j = 0 ; j < maps[curMap].cellsPerLine ; j++)
    {
      if (maps[curMap].map[endCell][j] >= 1 && maps[curMap].map[endCell][j] < 10)
      {
        fill(255);
        stroke(255);
        rect(border.get("left") + j * cellSize, border.get("top") + (endCell - startCell) * cellSize + offset, cellSize, cellSize);
      }
      if (maps[curMap].map[endCell][j] == 10)
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
      if (maps[curMap].map[startCell - 1][j] >= 1 && maps[curMap].map[startCell - 1][j] < 10)
      {
        fill(255);
        stroke(255);
        rect(border.get("left") + j * cellSize, border.get("top") + -1 * cellSize + offset, cellSize, cellSize);
      }
      if (maps[curMap].map[startCell - 1][j] == 10)
      {
        fill(0, 255, 255);
        stroke(0, 255, 255);
        rect(border.get("left") + j * cellSize, border.get("top") + -1 * cellSize + offset, cellSize, cellSize);
      }
    }
  }
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
  if (startCell != 0)
    text("/\\", width / 2, border.get("top"));
  textAlign(CENTER, TOP);
  if (endCell != maps[curMap].cellsPerCol)
    text("\\/", width / 2, height - border.get("bottom"));
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
      if ((enemy.cellPosition.y == 0 || enemy.cellPosition.x == 0 || enemy.cellPosition.x == maps[curMap].cellsPerLine - 1) && (enemy.road == road))
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

void mouseHover()
{ 
  // Move the screen up
  if (mouseY < border.get("top"))
  {
    if (startCell > 0) // && millis()> lastCheck + 100
    {
      offset += 10;
      if (offset > cellSize)
      {
        startCell --;
        endCell --;
        //lastCheck = millis();
        offset = 0;
      }
    }
  }
  // Move the screen down
  if (mouseY > border.get("top") + screenHeight)
  {
    if (endCell < maps[curMap].cellsPerCol) // && millis()> lastCheck + 100
    {
      offset -= 10;
      if (offset < -cellSize)
      {
        startCell ++;
        endCell ++;
        //lastCheck = millis();
        offset = 0;
      }
    }
  }
  
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
}

void keyPressed()
{
  if (key >= '1' && key <= '9')
  {
    curMap = key - '0' - 1;
    initialSettings();
  }
}