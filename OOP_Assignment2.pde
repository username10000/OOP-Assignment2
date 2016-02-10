import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import java.util.Hashtable;
import java.util.Map;

int cellsPerHeight;
int startCell, endCell;
int curMap;
int timePaused = 0;
ArrayList<Integer>[] noEnemiesTotal = (ArrayList<Integer>[]) new ArrayList[9];
ArrayList<Integer> noEnemies = new ArrayList<Integer>();
ArrayList<Integer> time = new ArrayList<Integer>();
ArrayList<Boolean> spawn = new ArrayList<Boolean>();
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
ArrayList<Button> buttons = new ArrayList<Button>();
ArrayList<GameObject> menuObjects = new ArrayList<GameObject>();
Player player;
PImage background;
PShape heart;
int[] towerPoints = {100, 200, 300};
boolean pause = false;
boolean hoverEnemy = false;
boolean mainMenu = true;
boolean menu = false;
boolean levelSelect = false;
boolean won = false;
boolean lost = false;
boolean imported = false;
int towerNo = 3;
int tempScore = 0;
int enemiesLeft = 0;
PVector towerMenu = new PVector(-1, -1, 0);
PVector upgradeMenu = new PVector(-1, -1, 0);
Minim minim;

void setup()
{
  //size(displayWidth, displayHeight);
  fullScreen();
  
  background(0);
  stroke(255);
  textAlign(CENTER);
  
  // Start the audio
  minim = new Minim(this);

  // Initial Settings
  initialSettings();

  // Main Menu Buttons
  int noButtons = 4;  
  float top = height / 3;
  float bottom = height - top;
  buttons.add(new Button("New Game", width / 2, map(1, 1, noButtons, top, bottom), 250, 50));
  ((Button)buttons.get(0)).setGroup("Main Menu");
  buttons.add(new Button("Load Game", width / 2, map(2, 1, noButtons, top, bottom), 250, 50));
  ((Button)buttons.get(1)).setGroup("Main Menu");
  buttons.add(new Button("Exit", width / 2, map(4, 1, noButtons, top, bottom), 250, 50));
  ((Button)buttons.get(2)).setGroup("Main Menu");
  
  // Level Select Buttons
  noButtons = 9;
  top = height / 5;
  bottom = height - top;
  float left = top;
  float right = width - left;
  float buttonWidth = (width - 2 * left - 4 * 20) / 5;
  float buttonHeight = (height - 2 * top - 4 * 40) / 2;
  for (int i = 0 ; i < noButtons ; i++)
  {
    buttons.add(new Button("Level " + (i + 1), map(i % 5, 0, 4, left, right), map(i / 5, 0, 1, top, bottom), buttonWidth, buttonHeight));
    buttons.get(i + 3).setGroup("Level Select");
  }
  
  // Menu Buttons
  noButtons = 3;
  top = height / 4;
  bottom = height - top;
  buttons.add(new Button("Resume", width / 2, map(1, 1, noButtons, top, bottom), 250, 50));
  buttons.get(12).setGroup("Menu");
  buttons.add(new Button("Level Select", width / 2, map(2, 1, noButtons, top, bottom), 250, 50));
  buttons.get(13).setGroup("Menu");
  buttons.add(new Button("Main Menu", width / 2, map(3, 1, noButtons, top, bottom), 250, 50));
  buttons.get(14).setGroup("Menu");
  
  top = height / 5;
  bottom = height - top;
  buttons.add(new Button("Return", map(9 % 5, 0, 4, left, right), map(9 / 5, 0, 1, top, bottom), buttonWidth, buttonHeight));
  buttons.get(15).setGroup("Level Select");
  
  noButtons = 4;  
  top = height / 3;
  bottom = height - top;
  buttons.add(new Button("Import Map", width / 2, map(3, 1, noButtons, top, bottom), 250, 50));
  ((Button)buttons.get(16)).setGroup("Main Menu");
  
  
  for (int i = 0 ; i < buttons.size() ; i++)
  {
    buttons.get(i).hide();
  }
  
  // Load an audio file so there is no lag when the first tower is placed
  AudioPlayer audio = minim.loadFile("/Sounds/zap.mp3");
  audio.pause();
  
  // Create Main Menu Enemies
  for (int i = 5 ; i <= 10 ; i++)
  {
    menuObjects.add(new Enemy(i, (height - 200) / 12, (height - 200) / 12 + 25, map(i, 5, 10, 100, height - 100)));
  }
  
}

void draw()
{
  // Draw the background
  background(232, 185, 12);

  if (mainMenu)
  {
    showGroup("Main Menu");
    // Draw the Main Menu
    for (int i = 0 ; i < buttons.size() ; i++)
    {
      if (buttons.get(i).group.equals("Main Menu"))
      {
        buttons.get(i).update();
        buttons.get(i).render();
      }
    }
    
    // Draw the entities from the main menu
    for (int i = 0 ; i < menuObjects.size() ; i++)
    {
      menuObjects.get(i).render();
    }
    
    float x = width - menuObjects.get(0).position.y;
    float y = map(1, 1, 3, 100, height - 100);
    float radius = 50;
    stroke(0);
    fill(255, 0, 0);
    triangle(x, y - radius, x - radius, y + radius, x + radius, y + radius);
    
    y = map(2, 1, 3, 100, height - 100);
    stroke(0);
    fill(0, 255, 0);
    triangle(x, y - radius, x - radius, y + radius, x + radius, y + radius);
    
    y = map(3, 1, 3, 100, height - 100);
    stroke(0);
    fill(0, 0, 255);
    triangle(x, y - radius, x - radius, y + radius, x + radius, y + radius);
    
    fill(0);
    textSize(100);
    textAlign(CENTER, CENTER);
    text("Polygon Wars", width / 2, height / 3 / 2);
  }
  else
  if (levelSelect)
  {
    showGroup("Level Select");
    // Draw the Level Select Screen
    for (int i = 0 ; i < buttons.size() ; i++)
    {
      if (buttons.get(i).group.equals("Level Select"))
      {
        buttons.get(i).update();
        buttons.get(i).render();
      }
    }
    
    // Draw the Total Score in the Level Select Menu
    fill(0);
    stroke(255);
    rectMode(CENTER);
    rect(width / 2, 25, 300, 50); 
    rectMode(CORNER);
    textAlign(CENTER, CENTER);
    fill(255);
    text(player.totalScore, width / 2, 25);
  }
  else
  {
    if (menu)
    {
      showGroup("Menu");
      pause = true;
      
      // Stop sounds when the menu is opened
      for (int i = 0 ; i < weapons.size() ; i++)
      {
        if (weapons.get(i) instanceof Pause)
        {
          ((Pause)weapons.get(i)).pause();
        }
      }
      
      // Don't display the level select button if the user is in the imported map
      if (imported)
      {
        buttons.get(13).hide();
      }
    }
    
    // Draw the background
    fill(maps[curMap].bColour);
    noStroke();
    rect(border.get("left"), border.get("top"), screenWidth, screenHeight);
  
    // Draw the occupied cells
    drawRoad();
  
    if (!pause)
    {
      // Add the time that was paused
      if (timePaused != 0)
      {
        for (int i = 0 ; i < noEnemies.size() ; i++)
        {
          time.set(i, time.get(i) + (millis() - timePaused));
        }
        timePaused = 0;
      }
     
      // Check if there are no enemies on the screen
      if (noEnemiesVisible() == 0)
      {
        int roadNo = (int)random(0, spawn.size() - 0.01);
        spawn.set(roadNo, true);
        time.set(roadNo, millis() + (int)random(5000, 10000));
      }
      
      // Create enemies
      for (int i = 0; i < noEnemies.size(); i++)
      {
        if (time.get(i) < millis())
        {
          spawn.set(i, !spawn.get(i));
          if (spawn.get(i))
          {
            time.set(i, millis() + (int)random(5000, 10000));
          }
          else
          {
            time.set(i, millis() + (int)random(20000, 30000));
          }
        }
        if (noEnemies.get(i) > 0 && i <= curMap && spawn.get(i))
        {
          createEnemy(i + 1);
        }
        println(noEnemies.get(i));
      }
  
      // Update objects
      for (int i = 0; i < objects.size() || i < weapons.size() || i < buttons.size(); i++)
      {
        if (i < objects.size())
          objects.get(i).update();
        if (i < weapons.size())
          weapons.get(i).update();
        if (i < buttons.size())
          buttons.get(i).update();
      }
    }
    else
    {
      // Get the time the game was paused for
      if (timePaused == 0)
        timePaused = millis();
      for (int i = 0 ; i < weapons.size() ; i++)
      {
        if (weapons.get(i) instanceof Pause)
        {
          ((Pause)weapons.get(i)).pause();
        }
      }
    }
  
    // Render enemies
    for (int i = 0; i < objects.size() || i < weapons.size() || i < buttons.size(); i++)
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
      if (i < buttons.size())
        buttons.get(i).render();
    }
  
    // Mark the cell if it's hovered
    if (mousePosition.z == 0 && towerMenu.x == -1 && upgradeMenu.x == -1)
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
  
      if (!hoverTower && !hoverEnemy)
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
      
      // Type 0 Tower
      if (player.points >= towerPoints[0])
        tempColour = color(255, 0, 0);
      else
        tempColour = color(100, 0, 0);
      tempPos.x += cellSize / 2;
      tempPos.y += cellSize / 2;
      
      // Draw Triangle
      stroke(0);
      fill(tempColour);
      triangle(tempPos.x, tempPos.y - halfSize, tempPos.x - halfSize, tempPos.y + halfSize, tempPos.x + halfSize, tempPos.y + halfSize);
      
      // Display Tower Cost
      textAlign(CENTER, CENTER);
      fill(0);
      textSize(12);
      text(towerPoints[0], tempPos.x, tempPos.y + cellSize - halfSize / 2);
      
      // Type 1 Tower
      if (player.points >= towerPoints[1])
        tempColour = color(0, 255, 0);
      else
        tempColour = color(0, 100, 0);
      tempPos.x += cellSize;
      
      // Draw Triangle
      stroke(0);
      fill(tempColour);
      triangle(tempPos.x, tempPos.y - halfSize, tempPos.x - halfSize, tempPos.y + halfSize, tempPos.x + halfSize, tempPos.y + halfSize);
      
      // Display Tower Cost
      textAlign(CENTER, CENTER);
      fill(0);
      textSize(12);
      text(towerPoints[1], tempPos.x, tempPos.y + cellSize - halfSize / 2);
      
      // Type 2 Tower
      if (player.points >= towerPoints[1])
        tempColour = color(0, 0, 255);
      else
        tempColour = color(0, 0, 100);
      tempPos.x += cellSize;
      
      // Draw Triangle
      stroke(0);
      fill(tempColour);
      triangle(tempPos.x, tempPos.y - halfSize, tempPos.x - halfSize, tempPos.y + halfSize, tempPos.x + halfSize, tempPos.y + halfSize);
      
      // Display Tower Cost
      textAlign(CENTER, CENTER);
      fill(0);
      textSize(12);
      text(towerPoints[2], tempPos.x, tempPos.y + cellSize - halfSize / 2);
    }
    
    // Draw the upgrade menu
    if (upgradeMenu.x != -1)
    {
      // Position and number of tower variables
      PVector tempPos;
      int tempCellPos = (int)upgradeMenu.x - (int)(towerNo / 2);
  
      // Menu colour and stroke
      stroke(0);
      fill(100);
  
      // Calculate the coordinates of the tower menu
      tempPos = new PVector(border.get("left") + tempCellPos * cellSize, border.get("top") + (upgradeMenu.y - startCell) * cellSize + offset);
  
      // Draw the menu
      rect(tempPos.x, tempPos.y, cellSize * towerNo, cellSize);
      
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(12);
      
      // Get the Tower location
      int towerClicked = checkTower((int)upgradeMenu.x + (int)upgradeMenu.z, (int)upgradeMenu.y);
      
      // First Upgrade
      if (((Tower)objects.get(towerClicked)).upgradeLevel[0] < 3 && player.points >= pow((towerPoints[((Tower)objects.get(towerClicked)).type] / 10), (((Tower)objects.get(towerClicked)).upgradeLevel[0] + 1)))
        fill(0);
      else
        fill(255, 0, 0);
      tempPos.x += cellSize / 2;
      tempPos.y += cellSize / 2;
      text("+DMG", tempPos.x, tempPos.y);
      
      // Display Upgrade Cost
      if (((Tower)objects.get(towerClicked)).upgradeLevel[0] < 3)
      {
        textAlign(CENTER, CENTER);
        fill(0);
        textSize(12);
        text((int)pow((towerPoints[((Tower)objects.get(towerClicked)).type] / 10), (((Tower)objects.get(towerClicked)).upgradeLevel[0] + 1)), tempPos.x, tempPos.y + cellSize - cellSize / 4);
      }
      
      // Second Upgrade
        if (((Tower)objects.get(towerClicked)).upgradeLevel[1] < 3 && player.points >= pow((towerPoints[((Tower)objects.get(towerClicked)).type] / 10), (((Tower)objects.get(towerClicked)).upgradeLevel[1] + 1)))
        fill(0);
      else
        fill(255, 0, 0);
      tempPos.x += cellSize;
      text("+SPD", tempPos.x, tempPos.y);
      
      // Display Upgrade Cost
      if (((Tower)objects.get(towerClicked)).upgradeLevel[1] < 3)
      {
        textAlign(CENTER, CENTER);
        fill(0);
        textSize(12);
        text((int)pow((towerPoints[((Tower)objects.get(towerClicked)).type] / 10), (((Tower)objects.get(towerClicked)).upgradeLevel[1] + 1)), tempPos.x, tempPos.y + cellSize - cellSize / 4);
      }
      
      // Third Upgrade
      if (((Tower)objects.get(towerClicked)).upgradeLevel[2] < 3 && player.points >= pow((towerPoints[((Tower)objects.get(towerClicked)).type] / 10), (((Tower)objects.get(towerClicked)).upgradeLevel[2] + 1)))
        fill(0);
      else
        fill(255, 0, 0);
      tempPos.x += cellSize;
      text("+RNG", tempPos.x, tempPos.y);
      
      // Display Upgrade Cost
      if (((Tower)objects.get(towerClicked)).upgradeLevel[2] < 3)
      {
        textAlign(CENTER, CENTER);
        fill(0);
        textSize(12);
        text((int)pow((towerPoints[((Tower)objects.get(towerClicked)).type] / 10), (((Tower)objects.get(towerClicked)).upgradeLevel[2] + 1)), tempPos.x, tempPos.y + cellSize - cellSize / 4);
      }
    }
  
    // Check if it's game over
    if (player.lives == 0)
      gameOver();
      
    if (gameWon())
    {
      //buttons.get(13).show();
      textSize(30);
      textAlign(CENTER, CENTER);
      fill(0, 255, 0);
      //text("You Won!", buttons.get(13).position.x, buttons.get(13).position.y - buttons.get(13).bHeight);
      text("You Won!", width / 2, height / 2);
      won = true; 
    }
      
    if (menu)
    {
      // Make the background darker
      stroke(0, 0, 0, 150);
      fill(0, 0, 0, 150);
      rect(0, 0, width, height);
      
      // Make a menu background
      //stroke(255, 255, 255);
      //fill(0, 255, 72);
      stroke(0, 255, 72, 175);
      fill(0, 255, 72, 175);
      rectMode(CENTER);
      rect(width / 2, height / 2, buttons.get(12).bWidth + buttons.get(12).bWidth / 2, (buttons.get(13).position.y - buttons.get(12).position.y + buttons.get(12).bHeight) * 2); //buttons.get(12).bHeight * 10
      rectMode(CORNER);
      
      // Draw the menu buttons
      for (int i = 0 ; i < buttons.size() ; i++)
      {
        if (buttons.get(i).group.equals("Menu"))
        {
          buttons.get(i).update();
          buttons.get(i).render();
        }
      }
      
      stroke(255);
      fill(0);
      rectMode(CENTER);
      rect(width / 2, 25, 300, 50); 
      rectMode(CORNER);
      textAlign(CENTER, CENTER);
      fill(255);
      text(tempScore, width / 2, 25);
    }
  }
}

void initialSettings()
{
  // Set the borders
  border.put("top", (float)0);
  border.put("bottom", (float)0);
  border.put("left", (float)0);
  border.put("right", (float)0);

  // Calculate the screen width and height
  screenWidth = width;// - border.get("left") - border.get("right");
  screenHeight = height;// - border.get("top") - border.get("bottom");

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

void randomVariables(int rSeed)
{
  randomSeed(rSeed);
  
  // Random maps
  for (int i = 0; i < maps.length; i++)
  {
    maps[i] = new MapObject(i + 1);
  }

  //player = new Player();
  
  // Create enemies
  for (int i = 0 ; i < noEnemiesTotal.length ; i++)
  {
    noEnemiesTotal[i] = new ArrayList<Integer>();
    for (int j = 0 ; j <= i ; j++)
    {
      noEnemiesTotal[i].add((int)random(40, 50));
    }
  }
}

void refreshSettings()
{
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
  //border.put("bottom", height - screenHeight - border.get("top"));
  startCell = 0;
  endCell = cellsPerHeight;
  offset = 0;
  noEnemies.clear();
  time.clear();
  spawn.clear();
  enemiesLeft = 0;
  //spawnDelay.clear();
  //spawnTime.clear();
  for (int i = 0 ; i < noEnemiesTotal[curMap].size() ; i++)
  {
    noEnemies.add(noEnemiesTotal[curMap].get(i));
    enemiesLeft += noEnemiesTotal[curMap].get(i);
    time.add(millis() + (int)random(5000, 10000));
    spawn.add(false);
    //spawnDelay.add(millis() + (int)random(5000, 10000));
    //spawnTime.add(0);
  }
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
        fill(255, 255, 255);
        stroke(255, 255, 255);
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
  
  // Draw number of enemies left
  padding = 2;
  noStroke();
  fill(0, 0, 0, 100);
  rect(width / 99 - padding, height - 30 - padding, 180, 30);
  fill(255);
  textAlign(LEFT, TOP);
  text("Enemies left: " + enemiesLeft, width / 99 + padding, height - 30 + padding);
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
    int noEdges;
    
    // Add Enemies with more than 5 edges at random times
    if ((int)random(0, 100) % (12 - curMap) == 0)
    {
      noEdges = (int)map(random(0, (10 - curMap) * 10), 0, (10 - curMap) * 10, 6, 10);
    }
    else
    {
      noEdges = 5;
    }
    
    // Create a new enemy
    Enemy enemy = new Enemy(noEdges, color(random(0, 255), random(0, 255), random(0, 255)), road);
    objects.add(enemy);
    // Decrease the amount of enemies in that road
    noEnemies.set(road - 1, noEnemies.get(road - 1) - 1);
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
              e1.setColour();
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
              e2.setColour();
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
      enemiesLeft --;
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

      if (dist(tempPos.x, tempPos.y, bullet.position.x, bullet.position.y) > bullet.fieldRadius)
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
    if (!objects.get(i).isAlive && objects.get(i) instanceof Enemy)
    {
      objects.remove(i);
      enemiesLeft --;
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
  lost = true;
}

void hideGroup(String g)
{
  for (int i = 0 ; i < buttons.size() ; i++)
    if (buttons.get(i).group.equals(g))
      buttons.get(i).hide();
}

void showGroup(String g)
{
  for (int i = 0 ; i < buttons.size() ; i++)
    if (buttons.get(i).group.equals(g))
      buttons.get(i).show();
}

int noEnemiesVisible()
{
  int count = 0;
  for (int i = 0 ; i < objects.size() ; i++)
  {
    if (objects.get(i) instanceof Enemy)
      count++;
  }
  return count;
}

boolean gameWon()
{
  int count = 0;
  for (int i = 0 ; i < objects.size() ; i++)
  {
    if (objects.get(i) instanceof Enemy)
      count ++;
  }
  if (count == 0)
  {
    for (int i = 0 ; i < noEnemies.size() ; i++)
      if (noEnemies.get(i) != 0)
        count ++;
    if (count == 0)
      return true;
  }
  return false;
}

void disableButtons()
{ 
  int count = 0;
  for (int i = 0 ; i < buttons.size(); i++)
  {
    if (buttons.get(i).group.equals("Level Select") && !buttons.get(i).text.equals("Return"))
    {
      if (count <= player.maxLevel)
      {
        buttons.get(i).enable();
        buttons.get(i).toolTip = "" + player.score[(buttons.get(i).text.charAt(buttons.get(i).text.length() - 1) - '0') - 1];
      }
      else
      {
        buttons.get(i).disable();
      }
        
      count ++;
    }
  }
}

void mouseHover()
{ 
  // Mark the selected cell
  if (mouseX > border.get("left") && mouseX < width - border.get("right") && mouseY > border.get("top") && mouseY < height - border.get("bottom") && !menu && !won && !lost)
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
  if ((mouseY < border.get("top") || mouseY < cellSize) && !menu)
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
  if ((mouseY > border.get("top") + screenHeight || mouseY > height - cellSize) && !menu)
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
  
  if (!menu)
  {
    // Hover over an Enemy
    hoverEnemy = false;
    for (int i = 0 ; i < objects.size() ; i++)
    {
      if (objects.get(i) instanceof Enemy)
      {
        if (dist(mouseX, mouseY, objects.get(i).position.x, objects.get(i).position.y) <= ((Enemy)objects.get(i)).radius)
        {
          ((Enemy)objects.get(i)).displayHealth();
          hoverEnemy = true;
        }
      }
    }
  }
}

void keyPressed()
{
  if (key == ESC || keyCode == ESC)
  {
    menu = !menu;
    key = 0;
    keyCode = 0;
    if (!menu)
    {
      hideGroup("Menu");
      pause = false;
    }
  }

  if (key == ' ')
  {
    pause = !pause;
  }
}

void keyReleased()
{
  if (key == ESC || keyCode == ESC)
  {
    key = 0;
    keyCode = 0;
  }
}

void keyTyped()
{
  if (key == ESC || keyCode == ESC)
  {
    key = 0;
    keyCode = 0;
  }
}

void mouseClicked()
{
  if (mousePosition.z == 0)
  {
    if (towerMenu.x == -1 && upgradeMenu.x == -1 && maps[curMap].map[(int)mousePosition.y + startCell][(int)mousePosition.x] == '0')
    {
      // There is no Menu currently opened
      if (checkTower((int)mousePosition.x, (int)mousePosition.y + startCell) == -1)
      {
        // Open Tower Menu
        if (mousePosition.x == 0)
        {
          towerMenu.x = 1;
          towerMenu.z = -1;
        }
        else
          if (mousePosition.x == maps[curMap].cellsPerLine - 1)
          {
            towerMenu.x = maps[curMap].cellsPerLine - 2;
            towerMenu.z = 1;
          }
          else
          {
            towerMenu.x = (int)mousePosition.x;
            towerMenu.z = 0;
          }
        towerMenu.y = (int)mousePosition.y + startCell;
      }
      else
      {
        // Open Upgrade Menu
        if (mousePosition.x == 0)
        {
          upgradeMenu.x = 1;
          upgradeMenu.z = -1;
        }
        else
          if (mousePosition.x == maps[curMap].cellsPerLine - 1)
          {
            upgradeMenu.x = maps[curMap].cellsPerLine - 2;
            upgradeMenu.z = 1;
          }
          else
          {
            upgradeMenu.x = (int)mousePosition.x;
            upgradeMenu.z = 0;
          }
        upgradeMenu.y = (int)mousePosition.y + startCell;
      }
    }
    else
    {
      // A Menu is already opened
      if (towerMenu.x != -1)
      {
        // Tower Menu is opened
        if ((int)mousePosition.x - (int)towerMenu.x > 1 || (int)mousePosition.x - (int)towerMenu.x < -1 || (int)mousePosition.y + startCell - (int)towerMenu.y != 0)
        {
          // Outside the Tower Menu
          towerMenu.x = -1;
          towerMenu.y = -1;
          towerMenu.z = -1;
        }
        else
        {
          // Inside the Tower Menu
          for (int i = 0; i <= 2; i++)
          {
            // Check if a Tower was selected
            if ((int)mousePosition.x == (int)towerMenu.x + i - 1 && (int)mousePosition.y + startCell == (int)towerMenu.y)
            {
              if (player.points >= towerPoints[i])
              {
                // Decrease the player's points
                player.points -= towerPoints[i];
  
                // Create the tower
                switch(i)
                {
                  case 0:
                  {
                    TowerBullet tower = new TowerBullet((int)towerMenu.x + (int)towerMenu.z, (int)towerMenu.y);
                    objects.add(tower);
                    break;
                  }
                  case 1:
                  {
                    TowerRay tower = new TowerRay((int)towerMenu.x + (int)towerMenu.z, (int)towerMenu.y);
                    objects.add(tower);
                    break;
                  }
                  case 2:
                  {
                    TowerField tower = new TowerField((int)towerMenu.x + (int)towerMenu.z, (int)towerMenu.y);
                    objects.add(tower);
                    break;
                  }
                  default:
                  {
                    break;
                  }
                }
                
                // Exit the Tower Menu if a tower was selected
                towerMenu.x = -1;
                towerMenu.y = -1;
                break;
              }
            }
          }
        }
      }
      else
      {
        // Upgrade Menu is opened
        if ((int)mousePosition.x - (int)upgradeMenu.x > 1 || (int)mousePosition.x - (int)upgradeMenu.x < -1 || (int)mousePosition.y + startCell - (int)upgradeMenu.y != 0)
        {
          // Outside Upgrade Menu
          upgradeMenu.x = -1;
          upgradeMenu.y = -1;
          upgradeMenu.z = -1;
        }
        else
        {
          // Inside Upgrade Menu
          for (int i = 0; i <= 2; i++)
          {
            // Check if a Tower was selected
            if ((int)mousePosition.x == (int)upgradeMenu.x + i - 1 && (int)mousePosition.y + startCell == (int)upgradeMenu.y)
            {
              int towerClicked = checkTower((int)upgradeMenu.x + (int)upgradeMenu.z, (int)upgradeMenu.y);
              
              // Create the tower
              if (((Tower)objects.get(towerClicked)).upgradeLevel[i] < 3 && player.points >= pow((towerPoints[((Tower)objects.get(towerClicked)).type] / 10), (((Tower)objects.get(towerClicked)).upgradeLevel[i] + 1)))
              {
                player.points -= pow((towerPoints[((Tower)objects.get(towerClicked)).type] / 10), (((Tower)objects.get(towerClicked)).upgradeLevel[i] + 1));
                switch(i)
                {
                  case 0:
                  {
                    ((DamageUp) objects.get(towerClicked)).DamageIncrease();
                    break;
                  }
                  case 1:
                  {
                    ((SpeedUp)objects.get(towerClicked)).SpeedIncrease();
                    break;
                  }
                  case 2:
                  {
                    ((RangeUp)objects.get(towerClicked)).RangeIncrease();
                    break;
                  }
                  default:
                  {
                    break;
                  }
                }
                
                // Exit the Upgrade Menu if a tower was selected
                upgradeMenu.x = -1;
                upgradeMenu.y = -1;
                break;
              }
              

            }
          }
        }
      }
    }
  }
  else
  {
    if (mainMenu)
    {
      for (int i = 0 ; i < buttons.size() ; i++)
      {
        if (buttons.get(i).group.equals("Main Menu") && buttons.get(i).active)
        {
          switch(buttons.get(i).text)
          {
            case "New Game":
            {
              mainMenu = false;
              levelSelect = true;
              
              player = new Player();
              
              // Save the data
              player.saveData("/data/Save/save.txt");
              
              // Create the maps and enemies
              randomVariables(player.seed);
              
              // Disable the buttons that are not available
              disableButtons();
              
              break;
            }
            case "Load Game":
            {
              mainMenu = false;
              levelSelect = true;
              
              player = new Player();
              
              // Load the data
              player.loadData("/Save/save.txt");
              
              // Create the maps and enemies
              randomVariables(player.seed);
              
              // Disable the butons that are not available
              disableButtons();
              
              break;
            }
            case "Import Map":
            {
              mainMenu = false;
              imported = true;
              
              player = new Player();
              
              importMap = new MapObject("/Import Map/map.txt");
              
              randomVariables(player.seed);
              
              curMap = 0;
              for (int j = 0 ; j < importMap.map.length ; j++)
              {
                for (int k = 0 ; k < importMap.map[j].length ; k++)
                {
                  if (importMap.map[j][k] > '0' && importMap.map[j][k] <= '9')
                  {
                    if (curMap < importMap.map[j][k] - '0')
                    {
                      curMap = importMap.map[j][k] - '0';
                    }
                  }
                }
              }
              curMap --;
              
              maps[curMap] = new MapObject("/Import Map/map.txt");
              
              refreshSettings();
              
              // Calculate the cell size
              cellSize = screenWidth / importMap.map[0].length;
            
              // Calculate how many rows of cols can fit on the screen and change the screen height and bottom border to match
              cellsPerHeight = (int)(screenHeight / cellSize) + 1;
              // Special case if the cells fit perfectly
              if ((screenHeight / cellSize) - (int)(screenHeight / cellSize) == 0)
              {
                cellsPerHeight --;
              }
              screenHeight = cellSize * cellsPerHeight;
              
              player.lives = 10;
              player.points = 99999;
              tempScore = 0;
              
              break;
            }
            case "Exit":
            {
              exit();
            }
            default:
            {
              break;
            }
          }
          hideGroup("Main Menu");
          break;
        }
      }
    }
    else
    if (levelSelect)
    {
      for (int  i = 0 ; i < buttons.size() ; i++)
      {
        if (buttons.get(i).group.equals("Level Select") && buttons.get(i).active && !buttons.get(i).text.equals("Return"))
        {
          curMap = (int)((buttons.get(i).text.charAt(buttons.get(i).text.length() - 1)) - '0') - 1;
          levelSelect = false;
          hideGroup("Level Select");
          refreshSettings();
          player.lives = 10;
          player.points = (curMap + 1) * 1000;
          tempScore = 0;
          break;
        }
        else
        if (buttons.get(i).text.equals("Return") && buttons.get(i).active)
        {
          mainMenu = true;
          levelSelect = false;
          hideGroup("Level Select");
        }
      }
    }
    else
    if (menu)
    {
      for (int i = 0 ; i < buttons.size() ; i++)
      {
        if (buttons.get(i).group.equals("Menu") && buttons.get(i).active)
        {
          switch(buttons.get(i).text)
          {
            case "Level Select":
            {
              levelSelect = true;
              pause = false;
              hideGroup("Menu");
              objects.clear();
              weapons.clear();
              break;
            }
            case "Main Menu":
            {
              mainMenu = true;
              pause = false;
              hideGroup("Menu");
              objects.clear();
              weapons.clear();
              imported = false;
              break;
            }
            default:
            {
              break;
            }
          }
          menu = false;
          hideGroup("Menu");
          pause = false;
        }
      }
    }
    else
    if (won)
    {
      if (imported)
      {
        mainMenu = true;
      }
      else
      {
        levelSelect = true;
      }
      pause = false;
      hideGroup("Menu");
      objects.clear();
      weapons.clear();
      menu = false;
      hideGroup("Menu");
      pause = false;
      won = false;
      if (player.maxLevel < 8 && player.maxLevel == curMap)
        player.maxLevel ++;
      if (tempScore > player.score[curMap] && !imported)
      {
        player.score[curMap] = tempScore;
        player.saveData("/data/Save/save.txt");
        player.setTotalScore();
      }
      if (imported)
        imported = false;
      disableButtons();
    }
    else
    if (lost)
    {
      if (imported)
      {
        mainMenu = true;
        imported = false;
      }
      else
      {
        levelSelect = true;
      }
      pause = false;
      objects.clear();
      weapons.clear();
      menu = false;
      lost = false;
    }
  }
}