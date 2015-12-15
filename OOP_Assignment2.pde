import java.util.Hashtable;
import java.util.Map;

int cellsPerLine = 15;
float screenSize;
float gap;
boolean[][] map = new boolean[cellsPerLine][cellsPerLine];
Map<String, Float> border = new HashMap<String, Float>();

void setup()
{
  //size(displayWidth, displayHeight);
  fullScreen();
  background(0);
  stroke(255);
  
  border.put("top", map(1, 0, 100, 0, height));
  border.put("bottom", map(1, 0, 100, 0, height));
  border.put("left", map(1, 0, 100, 0, width));
  border.put("right", map(1, 0, 100, 0, width));
  
  screenSize = height - border.get("top") - border.get("bottom");
  gap = map(2, 0, 100, 0, width);
  
  String[] lines = loadStrings("map.txt");
  for (int i = 0 ; i < cellsPerLine ; i++)
  {
    for (int j = 0 ; j < cellsPerLine ; j++)
    {
      if (lines[i].charAt(j) == '1')
      {
        map[i][j] = true;
      }
      else
      {
        map[i][j] = false;
      }
      print(map[i][j] + " ");
    }
    println();
  }
  
  // Change the size of the screen
  //surface.setSize(displayWidth / 2, displayHeight / 2);
}

void draw()
{
  noFill();
  rect(border.get("left"), border.get("top"), screenSize, screenSize);
  
  rect(border.get("left") + screenSize + gap, border.get("top"), width - border.get("left") - border.get("right") - screenSize - gap, screenSize);
  
  for (int i = 0 ; i <= cellsPerLine ; i++)
  {
    // Vertical lines
    line(map(i, 0, cellsPerLine, border.get("left"), border.get("left") + screenSize), border.get("top"), map(i, 0, cellsPerLine, border.get("left"), border.get("left") + screenSize), border.get("top") + screenSize);
    // Horizontal lines
    line(border.get("left"), map(i, 0, cellsPerLine, border.get("top"), border.get("top") + screenSize), border.get("left") + screenSize, map(i, 0, cellsPerLine, border.get("top"), border.get("top") + screenSize));
  }
  
  for (int i = 0 ; i < cellsPerLine ; i++)
  {
    for (int j = 0 ; j < cellsPerLine ; j++)
    {
      if (map[i][j])
      {
        float cellSize = screenSize / cellsPerLine;
        fill(255);
        rect(border.get("left") + j * cellSize, border.get("top") + i * cellSize, cellSize, cellSize);
      }
    }
  }
}