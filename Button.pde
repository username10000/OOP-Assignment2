public class Button
{
  PVector position;
  PShape shape;
  PShape hoverShape;
  PShape activeShape;
  PShape disableShape;
  float bWidth;
  float bHeight;
  float halfWidth;
  float halfHeight;
  color colour;
  color hoverColour;
  color activeColour;
  color textColour;
  color disableColour;
  boolean normal;
  boolean hover;
  boolean active;
  boolean disable;
  boolean playedSound;
  boolean playedActive;
  String text;
  String toolTip;
  String group;
  AudioSample hoverSample, activeSample;
  
  Button(String t, float x, float y, float w, float h)
  {
    position = new PVector(x, y);
    bWidth = w;
    bHeight = h;
    colour = color(12, 31, 232);
    hoverColour = color(40, 60, 255);
    activeColour = color(0, 0, 100);
    textColour = color(255, 255, 255);
    disableColour = color(127, 127, 127);
    normal = true;
    hover = false;
    active = false;
    disable = false;
    halfWidth = bWidth / 2;
    halfHeight = bHeight / 2;
    text = t;
    group = "Main";
    drawShape();
    toolTip = null;
    hoverSample = minim.loadSample("/Sounds/B1.wav", 512);
    activeSample = minim.loadSample("/Sounds/B0.wav", 512);
    playedSound = false;
  }
  Button(String t, float x, float y, float w, float h, color c1, color c2, color c3, color c4)
  {
    this(t, x, y, w, h);
    colour = c1;
    hoverColour = c2;
    activeColour = c3;
    textColour = c4;
    drawShape();
    //hoverSample = minim.loadSample("/Sounds/T0.wav", 512);
    //activeSample = minim.loadSample("/Sounds/T1.wav", 512);
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
    
    // Create Disabled Button
    disableShape = createShape(RECT, -halfWidth, -halfHeight, bWidth, bHeight);
    disableShape.setStroke(disableColour);
    disableShape.setStrokeWeight(1);
    disableShape.setFill(disableColour);
    
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
  
  public void disable()
  {
    disable = true;
  }
  
  public void enable()
  {
    disable = false;
  }
  
  public void render()
  {
    // Check if the button is visible
    if (normal || hover || active)
    {
      pushMatrix();
      translate(position.x, position.y);
      
      // Check Normal State
      if (disable)
        shape(disableShape);
      else
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
      
      // Display Text on the Button
      textAlign(CENTER, CENTER);
      textSize(20);
      fill(textColour);
      text(text, position.x, position.y);
    }
    
    // Display the ToolTip
    if (hover && toolTip != null)
    {
      fill(0);
      rect(mouseX + 20, mouseY + 10, 85, 35);
      fill(255);
      textAlign(LEFT, CENTER);
      text(toolTip, mouseX + 25, mouseY + 25);
      textAlign(CENTER, CENTER);
    }
  }

  public void update()
  {
    if ((normal || hover || active) && !disable)
    {
      if (mouseX > position.x - halfWidth && mouseX < position.x + halfWidth && mouseY > position.y - halfHeight && mouseY < position.y + halfHeight)
      {
        if (mousePressed)
        {
          if (!playedActive)
          {
            playedActive = true;
            activeSample.trigger();
          }
          
          normal = false;
          hover = false;
          active = true;
        }
        else
        {
          if (!playedSound)
          {
            playedSound = true;
            hoverSample.trigger();
          }
          
          normal = false;
          hover = true;
          active = false;
        }
      }
      else
      {
        playedSound = false;
        playedActive = false;
        normal = true;
        hover = false;
        active = false;
      }
    }
  }
}