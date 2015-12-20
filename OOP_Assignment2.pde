import java.util.Hashtable;
import java.util.Map;

int cellsPerHeight;
int startCell, endCell;
int lastCheck = millis();
float screenSize;
float gap;
float screenWidth, screenHeight;
float cellSize;
Map<String, Float> border = new HashMap<String, Float>();
PVector mousePosition = new PVector(-1, -1, -1);
MapObject[] maps = new MapObject[9];
MapObject importMap;
Enemy enemy;

void setup()
{
  //size(displayWidth, displayHeight);
  fullScreen();
  background(0);
  stroke(255);
  textAlign(CENTER);
  //randomSeed((int)random(5000));
  
  // Import a map from a file
  //importMap = new MapObject("map.txt");
  
  // Random maps
  for (int i = 0 ; i < maps.length ; i++)
  {
    maps[i] = new MapObject(i + 1);
  }
  
  // Initial Settings
  initialSettings();

  // New Enemy
  enemy = new Enemy(width / 2, height / 2, 5, 50, color(random(0, 255), random(0, 255), random(0, 255)));
  
  // Change the size of the screen
  //surface.setSize(displayWidth / 2, displayHeight / 2);
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
    if (maps[0].map[(int)mousePosition.x + startCell][(int)mousePosition.y] >= 1)
    {
      stroke(255, 0, 0);
      fill(255, 0, 0, 100);
    }
    else
    {
      stroke(0, 255, 0);
      fill(0, 255, 0, 100);
    }
    rect(border.get("left") + mousePosition.y * cellSize, border.get("top") + mousePosition.x * cellSize, cellSize, cellSize);
  }
  // Do stuff if the cell is clicked on
  if (mousePosition.z == 1)
  {
    // Check if the clicked cell is a tower and do things
  }
  
  // Draw the entities
  enemy.update();
  enemy.render();
  
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
  cellSize = screenWidth / maps[0].cellsPerLine;
  
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
    for (int j = 0 ; j < maps[0].cellsPerLine ; j++)
    {
      if (maps[0].map[i + startCell][j] >= 1 && maps[0].map[i + startCell][j] < 10)
      {
        fill(255);
        stroke(255);
        rect(border.get("left") + j * cellSize, border.get("top") + i * cellSize, cellSize, cellSize);
      }
      if (maps[0].map[i + startCell][j] == 10)
      {
        fill(0, 255, 255);
        stroke(0, 255, 255);
        rect(border.get("left") + j * cellSize, border.get("top") + i * cellSize, cellSize, cellSize);
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
  if (endCell != maps[0].cellsPerCol)
    text("\\/", width / 2, height - border.get("bottom"));
}

void mouseHover()
{ 
  // Move the screen up
  if (mouseY < border.get("top"))
  {
    if (startCell > 0 && millis()> lastCheck + 100)
    {
      startCell --;
      endCell --;
      lastCheck = millis();
    }
  }
  // Move the screen down
  if (mouseY > border.get("top") + screenHeight)
  {
    if (endCell < maps[0].cellsPerCol && millis()> lastCheck + 100)
    {
      startCell ++;
      endCell ++;
      lastCheck = millis();
    }
  }
  
  // Mark the selected cell
  if (mouseX > border.get("left") && mouseX < width - border.get("right") && mouseY > border.get("top") && mouseY < height - border.get("bottom"))
  {
    mousePosition.x = (int)map(mouseY, border.get("top"), height - border.get("bottom"), 0, cellsPerHeight);
    mousePosition.y = (int)map(mouseX, border.get("left"), width - border.get("right"), 0, maps[0].cellsPerLine);
    mousePosition.z = 0;
  }
  else
  {
    mousePosition.x = -1;
    mousePosition.y = -1;
    mousePosition.z = -1;
  }
}