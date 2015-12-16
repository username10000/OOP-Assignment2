import java.util.Hashtable;
import java.util.Map;

int cellsPerLine;
int cellsPerCol;
int cellsPerHeight;
int startCell, endCell;
int lastCheck = millis();
float screenSize;
float gap;
float screenWidth, screenHeight;
float cellSize;
int[][] map;
Map<String, Float> border = new HashMap<String, Float>();
PVector mousePosition = new PVector(-1, -1, -1);

void setup()
{
  //size(displayWidth, displayHeight);
  fullScreen();
  background(0);
  stroke(255);
  textAlign(CENTER);
  
  // Import a map from a file
  //importMap();
  
  // Random map
  randomMap();
  
  initialSettings();
  
  // Change the size of the screen
  //surface.setSize(displayWidth / 2, displayHeight / 2);
}

void draw()
{
  background(0);
  
  // Draw the borders of the screen
  noFill();
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
    if (map[(int)mousePosition.x + startCell][(int)mousePosition.y] >= 1)
    {
      stroke(255, 0, 0);
      fill(255, 0, 0, 50);
    }
    else
    {
      stroke(0, 255, 0);
      fill(0, 255, 0, 50);
    }
    rect(border.get("left") + mousePosition.y * cellSize, border.get("top") + mousePosition.x * cellSize, cellSize, cellSize);
  }
  // Do stuff if the cell is clicked on
  if (mousePosition.z == 1)
  {
    // Check if the clicked cell is a tower and do things
  }
  
  // Draw all the information needed on the screen
  drawInfo();
  
  // Check if the mouse is hovering something
  mouseHover();
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
  cellSize = screenWidth / cellsPerLine;
  
  // Calculate how many rows of cols can fit on the screen and change the screen height and bottom border to match
  cellsPerHeight = (int)(screenHeight / cellSize);
  screenHeight = cellSize * cellsPerHeight;
  border.put("bottom", height - screenHeight - border.get("top"));
  startCell = 0;
  endCell = cellsPerHeight;
}

void addToArray(ArrayList<PVector> array, PVector curValue)
{
  PVector temp = new PVector(0, 0);
  temp.x = curValue.x;
  temp.y = curValue.y;
  array.add(temp);
}

void randomMap()
{
  // Get a random odd value for the number of columns
  cellsPerLine = (int)random(20, 30);
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
  
  // Add the tower to defend in the middle
  map[cellsPerCol / 2][cellsPerLine / 2] = 9;
  
  ArrayList<PVector> road = new ArrayList<PVector>();
  PVector curRoad = new PVector((int)random(1, cellsPerLine - 2), 0);
  
  // Add the first element
  addToArray(road, curRoad);
  map[(int)curRoad.y][(int)curRoad.x] = 1;
  curRoad.y ++;
  
  // Very inefficient!!!
  while ((curRoad.x != cellsPerLine / 2 || curRoad.y != cellsPerCol / 2) && road.size() < 10)
  {
    PVector change = new PVector(0, (int)random(-1, 2));
    
    // Add next value of the road
    addToArray(road, curRoad);
    map[(int)curRoad.y][(int)curRoad.x] = 1;
    
    // Find next position of the road
    if (change.y != 0)
    {
      while (curRoad.y + change.y == 0 || curRoad.y + change.y == cellsPerCol - 1 || change.y == 0)
      {
        change.y = (int)random(-1, 2);
      }
    }
    else
    {
      change.x = (int)random(-1, 2);
      while(curRoad.x + change.x == 0 || curRoad.x + change.x == cellsPerLine - 1 || change.x == 0)
      {
        change.x = (int)random(-1, 2);
      }
    }
    
    // Add the change to the current value of the road
    curRoad.add(change);
  }
  
  /*
  for (int i = 0 ; i < road.size() ; i++)
  {
    map[(int)road.get(i).y][(int)road.get(i).x] = 1;
  }*/
  
  
}

void importMap()
{
  // Read the file
  String[] lines = loadStrings("map.txt");
  
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

void drawRoad()
{
  // Draw the occupied cells
  for (int i = 0 ; i < endCell - startCell ; i++)
  {
    for (int j = 0 ; j < cellsPerLine ; j++)
    {
      if (map[i + startCell][j] == 1)
      {
        fill(255);
        stroke(255);
        rect(border.get("left") + j * cellSize, border.get("top") + i * cellSize, cellSize, cellSize);
      }
      if (map[i + startCell][j] == 9)
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
  // Draw the top and bottom arrows
  fill(255);
  textAlign(CENTER, BOTTOM);
  if (startCell != 0)
    text("/\\", width / 2, border.get("top"));
  textAlign(CENTER, TOP);
  if (endCell != cellsPerCol)
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
    if (endCell < cellsPerCol && millis()> lastCheck + 100)
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
    mousePosition.y = (int)map(mouseX, border.get("left"), width - border.get("right"), 0, cellsPerLine);
    mousePosition.z = 0;
  }
  else
  {
    mousePosition.x = -1;
    mousePosition.y = -1;
    mousePosition.z = -1;
  }
}