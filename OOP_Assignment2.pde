import java.util.Hashtable;
import java.util.Map;

int cellsPerHeight;
int startCell, endCell;
//int lastCheck = millis();
int curMap = 8;
int[] noEnemies = new int[9];
float screenSize;
float gap;
float screenWidth, screenHeight;
float cellSize;
float offset;
Map<String, Float> border = new HashMap<String, Float>();
PVector mousePosition = new PVector(-1, -1, -1);
MapObject[] maps = new MapObject[9];
MapObject importMap;
ArrayList<GameObject> objects = new ArrayList<GameObject>();
ArrayList<Weapon> weapons = new ArrayList<Weapon>();
Player player;
PImage background;
PShape heart;
int[] towerPoints = {100, 200, 300};
boolean pause = false;
int towerNo = 3;
PVector towerMenu = new PVector(-1, -1);

void setup()
{
  //size(displayWidth, displayHeight);
  fullScreen();
  background(0);
  stroke(255);
  textAlign(CENTER);
  //randomSeed((int)random(5000));
  //randomSeed(5000);

  // Change the size of the screen
  //surface.setSize(displayWidth / 2, displayHeight / 2);

  // Import a map from a file
  //importMap = new MapObject("map.txt");

  // Random maps
  for (int i = 0; i < maps.length; i++)
  {
    maps[i] = new MapObject(i + 1);
  }

  player = new Player();

  //maps[8] = new MapObject("map.txt");

  // Output current array
  /*
  String[] output = new String[maps[curMap].map.length];
   for (int i = 0 ; i < maps[curMap].map.length ; i++)
   {
   for (int j = 0 ; j <maps[curMap].map[i].length ; j++)
   {
   if (j == 0)
   output[i] = "" + maps[curMap].map[i][j];
   else
   output[i] = output[i] + maps[curMap].map[i][j];
   }
   }
   saveStrings("array.txt", output);
   */

  // Initial Settings
  initialSettings();

  // New Enemy
  //createEnemy(1);
  for (int i = 0; i < noEnemies.length; i++)
  {
    noEnemies[i] = (int)random(10, 15);
  }

  //createMapImage();
}

void draw()
{
  background(0);

  // Draw the borders of the screen
  //noFill();
  fill(0, 92, 9);
  noStroke();
  //stroke(255);
  rect(border.get("left"), border.get("top"), screenWidth, screenHeight);

  // Only for debugging
  /*
  for (int i = 0 ; i <= cellsPerLine ; i++)
   {
   // Vertical Lines
   line(border.get("left") + cellSize * i, border.get("top"), border.get("left") + cellSize * i, border.get("top") + screenHeight);
   }
   for (int i = 0 ; i <= cellsPerHeight ; i++)
   {
   // Horizontal Lines
   line(border.get("left"), border.get("top") + cellSize * i, border.get("left") + screenWidth, border.get("top") + cellSize * i);
   }*/

  // Draw the occupied cells
  drawRoad();

  if (!pause)
  {
    // Create enemies
    for (int i = 0; i < noEnemies.length; i++)
    {
      if (noEnemies[i] > 0 && i <= curMap)
      {
        createEnemy(i + 1);
      }
    }

    // Update objects
    for (int i = 0; i < objects.size() || i < weapons.size(); i++)
    {
      if (i < objects.size())
        objects.get(i).update();
      if (i < weapons.size())
        weapons.get(i).update();
    }
  }

  // Render enemies
  for (int i = 0; i < objects.size() || i < weapons.size(); i++)
  {
    if (i < objects.size())
    {
      objects.get(i).render();
      if (objects.get(i) instanceof Tower)
      {
        Tower tempTower = (Tower)objects.get(i);
        tempTower.hover = false;
      }
    }
    if (i < weapons.size())
      weapons.get(i).render();
  }

  // Mark the cell if it's hovered
  if (mousePosition.z == 0 && towerMenu.x == -1)
  {
    // Check if the mouse is over a tower
    boolean hoverTower = false;
    for (int i = 0; i < objects.size(); i++)
    {
      if (objects.get(i) instanceof Tower)
      {
        Tower tempTower = (Tower)objects.get(i);
        if (mousePosition.x == tempTower.cellPosition.x && mousePosition.y + startCell == tempTower.cellPosition.y)
        {
          tempTower.hover = true;
          hoverTower = true;
        }
      }
    }

    if (!hoverTower)
    {
      // Change the colour of the selected cell depending if it's a valid position
      if (maps[curMap].map[(int)mousePosition.y + startCell][(int)mousePosition.x] >= '1' && maps[curMap].map[(int)mousePosition.y + startCell][(int)mousePosition.x] <= '9' || maps[curMap].map[(int)mousePosition.y + startCell][(int)mousePosition.x] == '*')
      {
        stroke(255, 0, 0);
        fill(255, 0, 0, 100);
      } else
      {
        stroke(0, 255, 0);
        fill(0, 255, 0, 100);
      }
      rect(border.get("left") + mousePosition.x * cellSize, border.get("top") + mousePosition.y * cellSize + offset, cellSize, cellSize);
    }
  }

  // Draw all the information needed on the screen
  printInfo();

  // Check if the mouse is hovering something
  mouseHover();

  // Draw the rect border on top of the enemies
  //noFill();
  //stroke(255);
  //rect(border.get("left"), border.get("top"), screenWidth, screenHeight);

  // Combine enemies if they collide
  combineEnemies();

  // Delete bullet and damage enemies
  bulletHit();

  // Delete dead objects
  deleteDeadObjects();

  // Draw tower select menu
  if (towerMenu.x != -1)
  {
    // Position and number of tower variables
    PVector tempPos;
    int tempCellPos = (int)towerMenu.x - (int)(towerNo / 2);

    // Menu colour and stroke
    stroke(0);
    fill(100);

    // Calculate the coordinates of the tower menu
    tempPos = new PVector(border.get("left") + tempCellPos * cellSize, border.get("top") + (towerMenu.y - startCell) * cellSize + offset);

    // Draw the menu
    rect(tempPos.x, tempPos.y, cellSize * towerNo, cellSize);
    
    // Draw the towers from which to select
    float halfSize = cellSize / 2 - (cellSize / 10);
    color tempColour;
    
    if (player.points >= towerPoints[0])
      tempColour = color(255, 0, 0);
    else
      tempColour = color(100, 0, 0);
    tempPos.x += cellSize / 2;
    tempPos.y += cellSize / 2;
    
    stroke(tempColour);
    fill(tempColour);
    triangle(tempPos.x, tempPos.y - halfSize, tempPos.x - halfSize, tempPos.y + halfSize, tempPos.x + halfSize, tempPos.y + halfSize);
    
    if (player.points >= towerPoints[1])
      tempColour = color(0, 255, 0);
    else
      tempColour = color(0, 100, 0);
    tempPos.x += cellSize;
    
    stroke(tempColour);
    fill(tempColour);
    triangle(tempPos.x, tempPos.y - halfSize, tempPos.x - halfSize, tempPos.y + halfSize, tempPos.x + halfSize, tempPos.y + halfSize);
    
    if (player.points >= towerPoints[1])
      tempColour = color(0, 0, 255);
    else
      tempColour = color(0, 0, 100);
    tempPos.x += cellSize;
    
    stroke(tempColour);
    fill(tempColour);
    triangle(tempPos.x, tempPos.y - halfSize, tempPos.x - halfSize, tempPos.y + halfSize, tempPos.x + halfSize, tempPos.y + halfSize);
  }

  // Check if it's game over
  if (player.lives == 0)
    gameOver();
}

void initialSettings()
{
  // Set the borders
  border.put("top", map(0, 0, 100, 0, height));
  border.put("bottom", map(0, 0, 100, 0, height));
  border.put("left", map(0, 0, 100, 0, width));
  border.put("right", map(0, 0, 100, 0, width));

  // Calculate the screen width and height
  screenWidth = width - border.get("left") - border.get("right");
  screenHeight = height - border.get("top") - border.get("bottom");

  // Calculate the cell size
  cellSize = screenWidth / maps[curMap].cellsPerLine;

  // Calculate how many rows of cols can fit on the screen and change the screen height and bottom border to match
  cellsPerHeight = (int)(screenHeight / cellSize) + 1;
  // Special case if the cells fit perfectly
  if ((screenHeight / cellSize) - (int)(screenHeight / cellSize) == 0)
  {
    cellsPerHeight --;
  }
  screenHeight = cellSize * cellsPerHeight;
  border.put("bottom", height - screenHeight - border.get("top"));
  startCell = 0;
  endCell = cellsPerHeight;

  int halfD = 15;
  heart = createShape();
  heart.beginShape();
  heart.stroke(255, 255, 255, 200);
  heart.fill(255, 0, 0, 200);
  heart.vertex(-halfD, -halfD);
  heart.vertex(halfD, -halfD);
  heart.vertex(halfD, halfD);
  heart.vertex(-halfD, halfD);
  heart.endShape(CLOSE);
}

void drawRoad()
{
  // Draw the occupied cells
  for (int i = 0; i < endCell - startCell; i++)
  {
    for (int j = 0; j < maps[curMap].cellsPerLine; j++)
    {
      if (maps[curMap].map[i + startCell][j] >= '1' && maps[curMap].map[i + startCell][j] <= '9')
      {
        fill(255);
        stroke(255);
        rect(border.get("left") + j * cellSize, border.get("top") + i * cellSize + offset, cellSize, cellSize);
      }
      if (maps[curMap].map[i + startCell][j] == '*')
      {
        fill(0, 255, 255);
        stroke(0, 255, 255);
        rect(border.get("left") + j * cellSize, border.get("top") + i * cellSize + offset, cellSize, cellSize);
      }
    }
  }

  if (offset < 0)
  {
    for (int j = 0; j < maps[curMap].cellsPerLine; j++)
    {
      if (maps[curMap].map[endCell][j] >= '1' && maps[curMap].map[endCell][j] <= '9')
      {
        fill(255);
        stroke(255);
        rect(border.get("left") + j * cellSize, border.get("top") + (endCell - startCell) * cellSize + offset, cellSize, cellSize);
      }
      if (maps[curMap].map[endCell][j] == '*')
      {
        fill(0, 255, 255);
        stroke(0, 255, 255);
        rect(border.get("left") + j * cellSize, border.get("top") + (endCell - startCell) * cellSize + offset, cellSize, cellSize);
      }
    }
  }
  if (offset > 0)
  {
    for (int j = 0; j < maps[curMap].cellsPerLine; j++)
    {
      if (maps[curMap].map[startCell - 1][j] >= '1' && maps[curMap].map[startCell - 1][j] <= '9')
      {
        fill(255);
        stroke(255);
        rect(border.get("left") + j * cellSize, border.get("top") + -1 * cellSize + offset, cellSize, cellSize);
      }
      if (maps[curMap].map[startCell - 1][j] == '*')
      {
        fill(0, 255, 255);
        stroke(0, 255, 255);
        rect(border.get("left") + j * cellSize, border.get("top") + -1 * cellSize + offset, cellSize, cellSize);
      }
    }
  }
}

void createMapImage()
{
  background = createImage((int)(maps[curMap].cellsPerLine * cellSize), (int)(maps[curMap].cellsPerCol * cellSize), RGB);

  for (int i = 0; i < (int)(maps[curMap].cellsPerCol * cellSize); i++)
  {
    for (int j = 0; j < (int)(maps[curMap].cellsPerLine * cellSize); j++)
    {
      background.pixels[i * width + j] = color(0, 255, 0);
    }
  }

  for (int i = 0; i < maps[curMap].cellsPerCol; i++)
  {
    for (int j = 0; j < maps[curMap].cellsPerLine; j++)
    {
      if (maps[curMap].map[i][j] >= '1' && maps[curMap].map[i][j] < '9')
      {
        for (int k = (int)(j * (int)cellSize); k <= j * cellSize + cellSize; k++)
        {
          for (int l = (int)(i * (int)cellSize); l <= i * cellSize + cellSize; l++)
          {
            background.pixels[l * width + k] = color(255, 255, 255);
          }
        }
      }
      if (maps[curMap].map[i][j] == '*')
      {
        for (int k = (int)(j * (int)cellSize); k <= j * cellSize + cellSize; k++)
        {
          for (int l = (int)(i * (int)cellSize); l <= i * cellSize + cellSize; l++)
          {
            background.pixels[l * width + k] = color(0, 255, 255);
          }
        }
      }
    }
  }

  background.save("background.jpg");

  /*
  // Draw the occupied cells
   for (int i = 0 ; i < endCell - startCell ; i++)
   {
   for (int j = 0 ; j < maps[curMap].cellsPerLine ; j++)
   {
   if (maps[curMap].map[i + startCell][j] >= 1 && maps[curMap].map[i + startCell][j] < 10)
   {
   fill(255);
   stroke(255);
   rect(border.get("left") + j * cellSize, border.get("top") + i * cellSize + offset, cellSize, cellSize);
   }
   if (maps[curMap].map[i + startCell][j] == 10)
   {
   fill(0, 255, 255);
   stroke(0, 255, 255);
   rect(border.get("left") + j * cellSize, border.get("top") + i * cellSize + offset, cellSize, cellSize);
   }
   }
   }
   */
}

void printInfo()
{
  int padding = 2;

  // Print points
  noStroke();
  fill(0, 0, 0, 100);
  rect(width / 99 - padding, height / 99 - padding, 150, 30);
  textAlign(LEFT, TOP);
  fill(255);
  textSize(20);
  text("Points: " + player.points, width / 99, height / 99);

  // Print lives
  for (int i = 0; i < player.lives; i++)
  {
    padding = ((int)heart.width + 20) * i;

    stroke(255);
    fill(255, 0, 0);
    pushMatrix();
    translate(width - width / 99 - padding - 10, height / 99 + heart.width);
    shape(heart);
    popMatrix();
  }
}

void createEnemy(int road)
{
  // Assume the spawn point is empty
  boolean empty = true;

  // Check if the spawn point of the road is empty
  for (int i = 0; i < objects.size(); i++)
  {
    if (objects.get(i) instanceof Enemy)
    {
      Enemy enemy = (Enemy)objects.get(i);
      if ((enemy.cellPosition.y == -1 || enemy.cellPosition.x == -1 || enemy.cellPosition.x == maps[curMap].cellsPerLine) && (enemy.road == road))
      {
        empty = false;
      }
    }
  }

  // If the spawn point is empty add a new enemy
  if (empty)
  {
    // Create a new enemy
    Enemy enemy = new Enemy(5, color(random(0, 255), random(0, 255), random(0, 255)), road);
    objects.add(enemy);
    // Decrease the amount of enemies in that road
    noEnemies[road - 1] --;
  }
}

boolean checkOrigin(Enemy e1, Enemy e2)
{
  if (e1.previousCell.x == e2.previousCell.x && e1.previousCell.y == e2.previousCell.y)
    return true;
  else
    return false;
}

void combineEnemies()
{
  // Check if two enemies collide
  for (int i = 0; i < objects.size(); i++)
  {
    for (int j = 0; j < objects.size(); j++)
    {
      // Check if the object is an Enemy
      if (i != j && objects.get(i) instanceof Enemy && objects.get(j) instanceof Enemy && objects.get(i).isAlive && objects.get(j).isAlive)
      {
        Enemy e1 = (Enemy)objects.get(i);
        Enemy e2 = (Enemy)objects.get(j);

        // Check if they are in the same cell
        //if (e1.cellPosition.x == e2.cellPosition.x && e1.cellPosition.y == e2.cellPosition.y && !checkOrigin(e1, e2)) //  && e1.checkIntersection(e1.cellPosition)
        if (dist(e1.position.x, e1.position.y, e2.position.x, e2.position.y) <= e1.radius && !(e1.cellPosition.x == -1 || e1.cellPosition.x == maps[curMap].cellsPerLine || e1.cellPosition.y == -1))
        {
          // Increase the bigger cell
          if (e1.edges > e2.edges)
          {
            // Kill the smaller enemy
            e2.isAlive = false;

            // Limit the edges of the polygon to 10
            if (e1.edges < 10)
            {
              // Increase the size of the bigger polygon
              e1.edges ++;
              e1.health += 50;
              e1.radius = map(e1.edges, 5, 10, cellSize / 4, cellSize / 2);
              e1.drawShape();
            }
          } else
          {
            // Kill the smaller enemy
            e1.isAlive = false;

            // Limit the edges of the polygon to 10
            if (e2.edges < 10)
            {
              // Increase the size of the bigger polygon
              e2.edges ++;
              e2.health += 50;
              e2.radius = map(e2.edges, 5, 10, cellSize / 4, cellSize / 2);
              e2.drawShape();
            }

            // Break the inner loop because the first enemy is dead so there is no need to check it
            break;
          }
        }
      }
    }
  }

  // Remove all enemies that are dead
  for (int i = 0; i < objects.size(); i++)
  {
    if (!objects.get(i).isAlive)
    {
      objects.remove(i);
    }
  }
}

void bulletHit()
{
  // Check if the bullet has hit an Enemy
  for (int i = 0; i < weapons.size(); i++)
  {
    for (int j = 0; j < objects.size(); j++)
    {
      if (objects.get(j) instanceof Enemy && weapons.get(i) instanceof Bullet && weapons.get(i).isAlive)
      {
        Enemy tempEnemy = (Enemy)objects.get(j);
        if (dist(weapons.get(i).position.x, weapons.get(i).position.y, tempEnemy.position.x, tempEnemy.position.y) < tempEnemy.radius + 5)
        {
          tempEnemy.health -= weapons.get(i).damage;
          weapons.get(i).isAlive = false;
        }
      }
    }
  }

  // Check if the bullet is out of range
  for (int i = 0; i < weapons.size(); i++)
  {
    if (weapons.get(i) instanceof Bullet)
    {
      Bullet bullet = (Bullet)weapons.get(i);
      PVector tempPos = new PVector(border.get("left") + cellSize / 2 + bullet.originCell.x * cellSize, border.get("top") + cellSize / 2 + (bullet.originCell.y - startCell) * cellSize + offset);

      if (dist(tempPos.x, tempPos.y, bullet.position.x, bullet.position.y) > 2 * cellSize + cellSize / 2)
        bullet.isAlive = false;
    }
  }

  // Delete the bullets that either hit or are out of range
  for (int i = 0; i < weapons.size(); i++)
    if (!weapons.get(i).isAlive && weapons.get(i) instanceof Bullet)
      weapons.remove(i);
}

void deleteDeadObjects()
{
  for (int i = 0; i < objects.size(); i++)
  {
    if (!objects.get(i).isAlive)
    {
      objects.remove(i);
    }
  }
}

int checkTower(int x, int y)
{
  for (int i = 0; i < objects.size(); i++)
  {
    if (objects.get(i) instanceof Tower)
    {
      Tower temp = (Tower)objects.get(i);
      if (temp.cellPosition.x == x && temp.cellPosition.y == y)
        return i;
    }
  }
  return -1;
}

void gameOver()
{
  // Display Game Over Message
  pause = true;
  textSize(30);
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width / 2, height / 2);
}

void mouseHover()
{ 
  // Mark the selected cell
  if (mouseX > border.get("left") && mouseX < width - border.get("right") && mouseY > border.get("top") && mouseY < height - border.get("bottom"))
  {
    mousePosition.x = (int)map(mouseX, border.get("left"), width - border.get("right"), 0, maps[curMap].cellsPerLine);
    mousePosition.y = (int)map(mouseY, border.get("top") + offset, height - border.get("bottom") + offset, 0, cellsPerHeight);
    mousePosition.z = 0;
  } else
  {
    mousePosition.x = -1;
    mousePosition.y = -1;
    mousePosition.z = -1;
  }

  // Move the screen up
  if (mouseY < border.get("top") || mouseY < cellSize)
  {
    if (startCell > 0)
    {
      offset += 10;
      if (offset > cellSize)
      {
        startCell --;
        endCell --;
        offset = 0;
      }
      mousePosition.z = -1;
    }
  }
  // Move the screen down
  if (mouseY > border.get("top") + screenHeight || mouseY > height - cellSize)
  {
    if (endCell < maps[curMap].cellsPerCol)
    {
      offset -= 10;
      if (offset < -cellSize)
      {
        startCell ++;
        endCell ++;
        offset = 0;
      }
      mousePosition.z = -1;
    }
  }
}

void keyPressed()
{
  if (key >= '1' && key <= '9')
  {
    curMap = key - '0' - 1;
    initialSettings();
  }
  if (key == ' ')
  {
    pause = !pause;
  }
}

void mouseClicked()
{
  if (mousePosition.z == 0)
  {
    if (maps[curMap].map[(int)mousePosition.y + startCell][(int)mousePosition.x] == '0' && towerMenu.x == -1 && checkTower((int)mousePosition.x, (int)mousePosition.y + startCell) == -1)
    {
      // Set the tower menu location
      if (mousePosition.x == 0)
        towerMenu.x = 1;
      else
        if (mousePosition.x == maps[curMap].cellsPerLine - 1)
          towerMenu.x = maps[curMap].cellsPerLine - 2;
        else
          towerMenu.x = (int)mousePosition.x;
      
      //towerMenu.x = (int)mousePosition.x;
      towerMenu.y = (int)mousePosition.y + startCell;
    } else
    {
      boolean selected = true;
      
      // Check if the cell clicked is in the tower menu
      if (towerMenu.x != -1)
      {
        for (int i = 0; i <= 2; i++)
        {
          if ((int)mousePosition.x == (int)towerMenu.x + i - 1 && (int)mousePosition.y + startCell == (int)towerMenu.y)
          {
            int type = i;
            if (player.points >= towerPoints[type])
            {
              // Decrease the player's points
              player.points -= towerPoints[type];

              // Create the tower
              switch(i)
              {
                case 0:
                {
                  TowerBullet tower = new TowerBullet((int)towerMenu.x, (int)towerMenu.y);
                  objects.add(tower);
                  break;
                }
                case 1:
                {
                  TowerRay tower = new TowerRay((int)towerMenu.x, (int)towerMenu.y);
                  objects.add(tower);
                  break;
                }
                case 2:
                {
                  TowerField tower = new TowerField((int)towerMenu.x, (int)towerMenu.y);
                  objects.add(tower);
                  break;
                }
                default:
                {
                  break;
                }
              }
              //Tower tower = new Tower(type, (int)towerMenu.x, (int)towerMenu.y);
              //objects.add(tower);
            }
            else
            {
              selected = false;
            }
          }
        }
      }
      else
      {
        int towerClicked = checkTower((int)mousePosition.x, (int)mousePosition.y + startCell);
        
        if (towerClicked > -1)
        {
          Tower tower = (Tower)objects.get(towerClicked);
          tower.DamageIncrease();
        }
      }
      
      // Deselect the tower menu if a tower was selected
      if (selected)
      {
        towerMenu.x = -1;
        towerMenu.y = -1;
      }
    }
  }
}