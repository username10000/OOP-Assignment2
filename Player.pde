public class Player
{
  int lives;
  int points;
  int[] score;
  int totalScore;
  int maxLevel;
  int seed;
  
  Player(int[] score, int seed, int maxLevel)
  {
    lives = 10;
    points = 1000;
    this.score = score;
    this.seed = seed;
    this.maxLevel = maxLevel;
    setTotalScore();
  }
  Player()
  {
    this(new int[9], (int)random(99999), 0);
  }
  
  public void setTotalScore()
  {
    totalScore = 0;
    for (int i = 0 ; i < score.length ; i++)
    {
      totalScore += score[i];
    }
  }
  
  public void saveData(String filename)
  {
    String[] output = new String[score.length + 2];
    output[0] = "" + seed;
    for (int j = 0 ; j < score.length ; j++)
    {
      output[j + 1] = "" + 0;
    }
    output[score.length + 1] = "" + 0;
    saveStrings(filename, output);
  }
  
  public void loadData(String filename)
  {
    String[] input = loadStrings(filename);
    seed = Integer.parseInt(input[0]);
    for (int j = 0 ; j < score.length ; j++)
    {
      score[j] = Integer.parseInt(input[j + 1]);
      totalScore += score[j];
    }
    maxLevel = Integer.parseInt(input[score.length + 1]);
  }
}