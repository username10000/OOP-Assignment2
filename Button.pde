public class Button
{
  PVector position;
  PShape shape;
  PShape hoverShape;
  PShape activeShape;
  float bWidth;
  float bHeight;
  float halfWidth;
  float halfHeight;
  color colour;
  color hoverColour;
  color activeColour;
  color textColour;
  boolean normal;
  boolean hover;
  boolean active;
  String text;
  String group;
  
  Button(String t, float x, float y, float w, float h)
  {
    position = new PVector(x, y);
    bWidth = w;
    bHeight = h;
    colour = color(0, 0, 150);
    hoverColour = color(0, 0, 255);
    activeColour = color(0, 0, 100);
    textColour = color(255, 255, 255);
    normal = true;
    hover = false;
    active = false;
    halfWidth = bWidth / 2;
    halfHeight = bHeight / 2;
    text = t;
    group = "Main";
    drawShape();
  }
  Button(String t, float x, float y, float w, float h, color c1, color c2, color c3, color c4)
  {
    this(t, x, y, w, h);
    colour = c1;
    hoverColour = c2;
    activeColour = c3;
    textColour = c4;
    drawShape();
  }
  Button()
  {
    this("Text", 0, 0, 50, 10);
  }
  
  private void drawShape()
  { 
    // Create Normal Button
    shape = createShape(RECT, -halfWidth, -halfHeight, bWidth, bHeight);
    shape.setStroke(colour);
    shape.setStrokeWeight(1);
    shape.setFill(colour); 
    
    // Create Hover Button
    hoverShape = createShape(RECT, -halfWidth, -halfHeight, bWidth, bHeight);
    hoverShape.setStroke(hoverColour);
    hoverShape.setStrokeWeight(1);
    hoverShape.setFill(hoverColour);
    
    // Create Active Button
    activeShape = createShape(RECT, -halfWidth, -halfHeight, bWidth, bHeight);
    activeShape.setStroke(activeColour);
    activeShape.setStrokeWeight(1);
    activeShape.setFill(activeColour);
  }
  
  public void hide()
  {
    normal = false;
    hover = false;
    active = false;
  }
  
  public void show()
  {
    normal = true;
    hover = false;
    active = false;
  }
  
  public void setGroup(String name)
  {
    group = name;
  }
  
  public void render()
  {
    // Check if the button is visible
    if (normal || hover || active)
    {
      pushMatrix();
      translate(position.x, position.y);
      
      // Check Normal State
      if (normal)
      {
        shape(shape);
      }
      if (hover)
      {
        shape(hoverShape);
      }
      if (active)
      {
        shape(activeShape);
      }
      
      popMatrix();
      textAlign(CENTER, CENTER);
      textSize(20);
      fill(textColour);
      text(text, position.x, position.y);
    }
  }

  public void update()
  {
    if (normal || hover || active)
    {
      if (mouseX > position.x - halfWidth && mouseX < position.x + halfWidth && mouseY > position.y - halfHeight && mouseY < position.y + halfHeight)
      {
        if (mousePressed)
        {
          normal = false;
          hover = false;
          active = true;
        }
        else
        {
          normal = false;
          hover = true;
          active = false;
        }
      }
      else
      {
        normal = true;
        hover = false;
        active = false;
      }
    }
  }
}