public class Enemy extends GameObject
{
  int edges;
  int life;
  float radius;
  float speed;
  PShape polygon;
  PVector cellPosition;
  
  Enemy(int edges, int life, color colour)
  {
    super(500, 500, colour);
    this.edges = edges;
    this.life = life;
    radius = map(edges, 5, 10, cellSize / 4, cellSize / 2);
    //cellPosition = new PVector(0, 0);
    speed = 0.02;
    drawShape();
    cellPosition = getStart(1);
  }
  Enemy()
  {
    this(5, 50, color(0, 0, 0));
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
  public void update()
  {
    // Update the location of the enemy
    //cellPosition.y += speed;
    position.x = border.get("left") + cellSize / 2 + cellPosition.x * cellSize;
    position.y = border.get("top") + cellSize / 2 + (cellPosition.y - startCell) * cellSize + offset;
  }
}