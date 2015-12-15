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
boolean[][] map;
Map<String, Float> border = new HashMap<String, Float>();

void setup()
{
  //size(displayWidth, displayHeight);
  fullScreen();
  background(0);
  stroke(255);
  
  // Import a map from a file
  importMap();
  
  // Set the borders
  border.put("top", map(1, 0, 100, 0, height));
  border.put("bottom", map(1, 0, 100, 0, height));
  border.put("left", map(1, 0, 100, 0, width));
  border.put("right", map(1, 0, 100, 0, width));

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
  for (int i = 0 ; i <= endCell - startCell ; i++)
  {
    // Horizontal Lines
    line(border.get("left"), border.get("top") + cellSize * i, border.get("left") + screenWidth, border.get("top") + cellSize * i);
  }
  
  // Draw the occupied cells
  for (int i = 0 ; i < endCell - startCell ; i++)
  {
    for (int j = 0 ; j < cellsPerLine ; j++)
    {
      if (map[i + startCell][j])
      {
        fill(255);
        rect(border.get("left") + j * cellSize, border.get("top") + i * cellSize, cellSize, cellSize);
      }
    }
  }
  
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
  map = new boolean[cellsPerLine][cellsPerCol];
  
  // Get the 2D array
  for (int i = 0 ; i < cellsPerLine ; i++)
  {
    for (int j = 0 ; j < cellsPerCol ; j++)
    {
      if (lines[i].charAt(j) == '1')
      {
        map[i][j] = true;
      }
      else
      {
        map[i][j] = false;
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
}