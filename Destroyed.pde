public class Destroyed extends GameObject 
{
  PVector cellPosition;
  PVector shapeOffset;
  float[] debris;
  float radius;
  float debrisRadius;
  float angle;
  float lineSize;
  int startTime;
  int edges;
  AudioPlayer audio;
  
  Destroyed(float x, float y, float xOffset, float yOffset, int edges, color colour)
  {
    cellPosition = new PVector(x, y);
    shapeOffset = new PVector(xOffset, yOffset);
    this.edges = edges;
    radius = map(edges, 5, 10, cellSize / 4, cellSize / 2);
    this.colour = colour;
    startTime = millis();
    debris = new float[edges];
    for (int i = 0 ; i < debris.length ; i++)
    {
      debris[i] = random(0, TWO_PI);
    }
    debrisRadius = 0;
    angle = 0;
    lineSize = 4;
    
    audio = minim.loadFile("/Sounds/enemy.wav");
    audio.rewind();
    audio.play();
  }
  Destroyed(float x, float y, float xOffset, float yOffset, int edges)
  {
    this(x, y, xOffset, yOffset, edges, color(0));
    colour = color(0);
  }
  Destroyed()
  {
    this(0, 0, 0, 0, 0, color(0));
  }
    
  void render()
  {
    // Calculate the coordinates of the object
    position.x = border.get("left") + cellSize / 2 + (cellPosition.x + shapeOffset.x) * cellSize;
    position.y = border.get("top") + cellSize / 2 + (cellPosition.y - startCell + shapeOffset.y) * cellSize + offset;
    
    // Draw the animation
    for (int i = 0 ; i < debris.length ; i++)
    {
      float x = position.x + sin(debris[i]) * debrisRadius;
      float y = position.y - cos(debris[i]) * debrisRadius;
      
      pushMatrix();
      translate(x, y);
      rotate(angle);
      strokeWeight(3);
      stroke(colour);
      if (lineSize != 0)
        line(0, -lineSize, 0, lineSize);
      strokeWeight(1);
      popMatrix();
    }
    
    debrisRadius += 0.2;
    angle += 0.05;
    if (lineSize != 0)
      lineSize -= 0.1;
    if (lineSize < 0)
      lineSize = 0;
    
    //stroke(colour);
    //fill(colour);
    //ellipse(position.x, position.y, radius * 2, radius * 2);
    
    //println(cellPosition.x + " " + cellPosition.y);
    
    //println(cellPosition.x + " " + cellPosition.y + " " + debris.length);
  }
  
  void update()
  {
    
    //if (millis() - startTime > 1000)
    if (debrisRadius >= radius)
      destroyed.remove(this);
  }
}