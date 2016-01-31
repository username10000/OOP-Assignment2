public class Player
{
  int lives;
  int points;
  int[] score;
  
  Player(int[] score)
  {
    lives = 10;
    points = 1000;
    this.score = score;
  }
  Player()
  {
    this(new int[9]);
  }
}