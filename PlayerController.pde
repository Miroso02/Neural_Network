public class PlayerController {
  ArrayList<Player> players = new ArrayList<Player>();
  ArrayList<Player> dead = new ArrayList<Player>();
  int numOfPlayers;
  private int numOfChampions;
  private int childrenPerChampion;
  /*int generation;
  int score;
  int highscore;*/
  
  public PlayerController(int nOfPl, int nOfCh) {
    numOfPlayers = nOfPl;
    numOfChampions = nOfCh;
    childrenPerChampion = (int)((nOfPl - nOfCh) / nOfCh);
    /*generation = 1;
    score = 0;
    highscore = 0;*/
    
    for (int i = 0; i < nOfPl; i++) {
      players.add(new Player());
    }
  }
  
  public void simulate() {
    //score++;
    for (Player p : players) {
      p.think();
      p.move();
      p.update();
    }
    removeKilledPlayers();
  }
  
  public boolean allDead() {
    return players.size() == 0;
  }
  
  private void removeKilledPlayers() {
    ArrayList<Player> deadPlayers = new ArrayList<Player>();
    for (int i = 0; i < players.size(); i++) {
      Player p = players.get(i);
      if (p.dead) {
        deadPlayers.add(p);
        dead.add(p);
      }
    }
    
    for (Player p: deadPlayers) {
      players.remove(p);
    }
  }
  
  public void createNewGen() {
    for (Player p: dead) {
      if (p.best == highscore) players.add(p);
    }
    for (int i = numOfPlayers - 1; i > numOfPlayers - 1 - numOfChampions; i--) {
      Player champion = dead.get(i);
      players.add(champion);
      for (int j = 0; j < childrenPerChampion; j++) {
        Player p = new Player();
        p.reset(champion.nn, true);
        players.add(p);
      }
    }
    dead.clear();
  }
  
  public void display() {
    fill(0);
    text("Score " + score, width - 300, 100);
    text("Best " + highscore, width - 300, 200);
    for (Player p : players) {
      p.display();
    }
  }
}