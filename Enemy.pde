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
    super(100, 100, colour);
    this.edges = edges;
    this.life = life;
    radius = map(edges, 5, 10, cellSize / 4, cellSize / 2);
    cellPosition = new PVector(0, 0);
    speed = 0.02;
    drawShape();
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
  public void render()
  {
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
    cellPosition.y += speed;
    position.x = border.get("left") + cellSize / 2 + cellPosition.x * cellSize;
    position.y = border.get("top") + cellSize / 2 + (cellPosition.y - startCell) * cellSize + offset;
  }
}