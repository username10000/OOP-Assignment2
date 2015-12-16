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
  importMap();
  
  // Set the borders
  border.put("top", map(2, 0, 100, 0, height));
  border.put("bottom", map(2, 0, 100, 0, height));
  border.put("left", map(2, 0, 100, 0, width));
  border.put("right", map(2, 0, 100, 0, width));

  //screenSize = height - border.get("top") - border.get("bottom");
  //gap = map(2, 0, 100, 0, width);
  
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
  
  // Change the size of the screen
  //surface.setSize(displayWidth / 2, displayHeight / 2);
}

void draw()
{
  background(0);
  
  noFill();
  stroke(255);
  rect(border.get("left"), border.get("top"), screenWidth, screenHeight);
  
  for (int i = 0 ; i <= cellsPerLine ; i++)
  {
    // Vertical Lines
    line(border.get("left") + cellSize * i, border.get("top"), border.get("left") + cellSize * i, border.get("top") + screenHeight);
  }
  for (int i = 0 ; i <= cellsPerHeight ; i++)
  {
    // Horizontal Lines
    line(border.get("left"), border.get("top") + cellSize * i, border.get("left") + screenWidth, border.get("top") + cellSize * i);
  }
  
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
    }
  }
  
  // Mark the cell if it's hovered
  if (mousePosition.z == 0)
  {
    // Change the colour of the selected cell depending if it's a valid position
    if (map[(int)mousePosition.x + startCell][(int)mousePosition.y] > 1)
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
  
  // Draw the top and bottom arrows
  fill(255);
  if (startCell != 0)
    text("/\\", width / 2, border.get("top") / 2);
  if (endCell != cellsPerCol)
    text("\\/", width / 2, height - border.get("bottom") / 2);
  
  // Check if the mouse is hovering something
  mouseHover();
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