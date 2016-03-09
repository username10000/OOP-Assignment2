public class Particle extends GameObject
{
  PVector sPos;
  PVector ePos;
  float angle;
  float distance;
  float lifeTime;
  
  Particle(float cx, float cy, float epx, float epy)
  {
    sPos = new PVector(border.get("left") + cellSize / 2 + cx * cellSize, border.get("top") + cellSize / 2 + (cy - startCell) * cellSize + offset);
    ePos = new PVector(epx, epy);
    angle = atan2(ePos.y - sPos.y, ePos.x - sPos.x);
    if (angle < 0)
      angle += TWO_PI;
    angle += PI / 4;
    distance = random(0, dist(sPos.x, sPos.y, ePos.x, ePos.y));
    angle += 0.5;
    lifeTime = millis() + random(10, 100);
  }
  
  void render()
  {
    stroke(0);
    strokeWeight(5);
    point(sPos.x + sin(angle) * distance, sPos.y - cos(angle) * distance);
    strokeWeight(1);
  }
  
  void update()
  {
    angle += 0.01;
  }
}