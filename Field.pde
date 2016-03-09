public class Field extends Weapon implements Pause
{
  PVector cellPosition;
  float fieldRadius;
  int lastFired;
  int lastLine;
  AudioPlayer audio;
  AudioSample sample;
  
  Field(float x, float y, color colour, float speed, float damage)
  {
    super(x, y, colour, speed, damage);
    cellPosition = new PVector(x, y);
    fieldRadius = 2 * cellSize + cellSize / 2;
    lastFired = millis();
    lastLine = millis();
  }
  Field()
  {
    this(0, 0, color(255), 0.5, 1);
  }
  
  public void pause()
  {
    //audio.pause();
  }
  public void render()
  {
    // Calculate the coordinates
    position.x = border.get("left") + cellSize / 2 + cellPosition.x * cellSize;
    position.y = border.get("top") + cellSize / 2 + (cellPosition.y - startCell) * cellSize + offset;
    
    strokeWeight(2);
    stroke(0, 0, 255, 50);
    fill(0, 0, 255, 50);
    ellipse(position.x, position.y, fieldRadius * 2, fieldRadius * 2);
    strokeWeight(1);
    
    if (lastLine + 1000 * speed < millis())
    {
      float angle = random(0, TWO_PI);
      float x = position.x + sin(angle) * fieldRadius / 2;
      float y = position.y - cos(angle) * fieldRadius / 2;
      stroke(0, 255, 255);
      strokeWeight(5);
      line(position.x, position.y, x, y);
      if (random(-1, 1) < 0)
        angle += PI / 5;
      else
        angle -= PI / 5;
      float newX = position.x + sin(angle) * fieldRadius / 2;
      float newY = position.y - cos(angle) * fieldRadius / 2;
      line(x, y, newX, newY);
      x = newX;
      y = newY;
      newX = position.x + sin(angle) * fieldRadius;
      newY = position.y - cos(angle) * fieldRadius;
      line(x, y, newX, newY);
      strokeWeight(1);
      lastLine = millis();
    }
    
  }
  public void update()
  {
    if (lastFired + 1000 * speed < millis())
    {
      // Calculate the coordinates
      position.x = border.get("left") + cellSize / 2 + cellPosition.x * cellSize;
      position.y = border.get("top") + cellSize / 2 + (cellPosition.y - startCell) * cellSize + offset;
      
      boolean soundPlayer = false;
      for (int i = 0 ; i < objects.size() ; i++)
      {
        if (objects.get(i) instanceof Enemy)
        {
          Enemy e = (Enemy)objects.get(i);
          
          // Damage the enemy in the area
          if (dist(position.x, position.y, objects.get(i).position.x, objects.get(i).position.y) <= fieldRadius)
          {
            e.health -= damage;
            //audio.loop();
            sample.trigger();
            soundPlayer = true;
          }
        }
      }
      
      if (!soundPlayer)
      {
        //audio.pause();
        //audio.rewind();
      }
      
      // Reset time
      lastFired = millis();
    }
  }
}