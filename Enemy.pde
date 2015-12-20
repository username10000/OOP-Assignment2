public class Enemy extends GameObject
{
  int edges;
  int life;
  float radius;
  float theta;
  PShape polygon;
  PVector cellPosition;
  
  Enemy(float x, float y, int edges, int life, color colour)
  {
    super(x, y, colour);
    this.edges = edges;
    this.life = life;
    theta = 0;
    radius = map(edges, 5, 10, cellSize / 4, cellSize / 2);
    cellPosition = new PVector(0, 0);
    drawShape();
  }
  Enemy()
  {
    this(width / 2, height / 2, 5, 50, color(0, 0, 0));
  }
  
  private void drawShape()
  {
    // Create the shape and change its colour
    polygon = createShape();
    polygon.beginShape();
    polygon.stroke(colour);
    polygon.fill(colour);
    for (int i = 0 ; i < edges ; i++)
    {
      theta = i * (TWO_PI / edges);
      
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
    cellPosition.y += 0.01;
    position.x = border.get("left") + cellSize / 2 + cellPosition.x * cellSize;
    position.y = border.get("top") + cellSize / 2 + (cellPosition.y - startCell) * cellSize;
  }
}