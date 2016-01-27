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
  boolean[] state;
  String text;
  String group;
  
  Button(String t, float x, float y, float w, float h)
  {
    position = new PVector(x, y);
    bWidth = w;
    bHeight = h;
    colour = color(0, 0, 150);
    hoverColour = color(0, 0, 255);
    activeColour = color(0, 0, 200);
    state = new boolean[3];
    state[0] = true;
    state[1] = false;
    state[2] = false;
    halfWidth = bWidth / 2;
    halfHeight = bHeight / 2;
    text = t;
    group = "Main";
    drawShape();
  }
  Button(String t, float x, float y, float w, float h, color c1, color c2, color c3)
  {
    this(t, x, y, w, h);
    colour = c1;
    hoverColour = c2;
    activeColour = c3;
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
    state[0] = false;
    state[1] = false;
    state[2] = false;
  }
  
  public void show()
  {
    state[0] = true;
    state[1] = false;
    state[2] = false;
  }
  
  public void setGroup(String name)
  {
    group = name;
  }
  
  public void render()
  {
    // Check if the button is visible
    if (state[0] || state[1] || state[2])
    {
      pushMatrix();
      translate(position.x, position.y);
      
      // Check Normal State
      if (state[0])
      {
        shape(shape);
      }
      if (state[1])
      {
        shape(hoverShape);
      }
      if (state[2])
      {
        shape(activeShape);
      }
      
      popMatrix();
      textAlign(CENTER, CENTER);
      textSize(20);
      text(text, position.x, position.y);
    }
  }

  public void update()
  {
    if (state[0] || state[1] || state[2])
    {
      if (mouseX > position.x - halfWidth && mouseX < position.x + halfWidth && mouseY > position.y - halfHeight && mouseY < position.y + halfHeight)
      {
        if (mousePressed)
        {
          state[0] = false;
          state[1] = false;
          state[2] = true;
        }
        else
        {
          state[0] = false;
          state[1] = true;
          state[2] = false;
        }
      }
      else
      {
        state[0] = true;
        state[1] = false;
        state[2] = false;
      }
    }
  }
}