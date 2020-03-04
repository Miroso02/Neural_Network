Meteor[] meteors = new Meteor[20]; //obstacles
Player[] players = new Player[45]; //AIs
ArrayList<Player> players0 = new ArrayList<Player>();
ArrayList<Player> dead = new ArrayList<Player>();
int generation;
int score;
int highscore;
final float METEOR_SPEED = 4;
final float PLAYER_SPEED = 10;

void setup() {
  size(displayWidth, displayHeight);
  //size(720, 1280);
  noStroke();
  textSize(60);
  generation = 1;
  score = 0;
  highscore = 0;

  for (int i = 0; i < meteors.length; i++) {
    meteors[i] = new Meteor();
  }

  for (int i = 0; i < 45; i++) {
    players0.add(new Player());
    players[i] = new Player();
  }
}

void draw() {
  background(155);
  fill(0);
  text("Gen " + generation, 100, 100);
  
  boolean allDead = false;
  if (!mousePressed) {
    simulate();
    allDead = true; //all players are dead
    for (Player p : players) {
      if (!p.dead) {
        allDead = false;  //if at least 1 is alive
        break;
      }
    }
    displaySimulation();
    if (allDead) createNewGeneration();
    return;
  }
  while(!allDead) {
    simulate();
    allDead = true; //all players are dead
    for (Player p : players) {
      if (!p.dead) {
        allDead = false;  //if at least 1 is alive
        break;
      }
    }
  }

  if (allDead) createNewGeneration();//look↓
}

void simulate() {
  score++;
  for (Meteor a : meteors) {
    a.move();
    if (a.isTouchingBorder()) a.reset();
  }

  for (Player p : players) {
    if (!p.dead) {
      p.think();
      p.move();
    }
    p.update();
  }
}
void displaySimulation() {
  for (Meteor a : meteors) {
    a.display();
  }

  fill(0);
  text("Score " + score, width - 300, 100);
  text("Best " + highscore, width - 300, 200);

  for (Player p : players) {
    if (!p.dead) {
      p.display();
    }
  }
}

void createNewGeneration() {
  //println("Gen " + generation + "; score: " + score + "; highscore: " + highscore);
  generation++;
  if (highscore < score) highscore = score;
  score = 0;

  int champion = 0;
  int champion2 = 0;
  int champion3 = 0;
  int champion4 = 0;
  for (int i = 0; i<players.length; i++) {
    if (players[champion].lifeTime < players[i].lifeTime) {
      champion = i;
    }
  }
  for (int i=0; i<players.length; i++)
  {
    if (players[champion2].lifeTime<players[i].lifeTime)
    {
      if (i!=champion)
        champion2=i;
    }
  }
  for (int i=0; i<players.length; i++)
  {
    if (players[champion3].lifeTime<players[i].lifeTime)
    {
      if (i!=champion && i!=champion2)
        champion3=i;
    }
  }
  for (int i=0; i<players.length; i++)
  {
    if (players[champion4].lifeTime<players[i].lifeTime)
    {
      if (i!=champion && i!=champion2 && i!=champion3)
        champion4=i;
    }
  }

  int num=40;
  for (int i = 0; i < players.length; i++)
  {
    if (i==champion || i==champion2 || i==champion3 ||
      i==champion4 || players[i].best==highscore)
    { players[i].reset(players[champion].nn, false);
      players[i].isChampion = true;
      continue;
    }
    int chIndex = 0;
    if (num > 30) chIndex = champion;
    else if (num > 20) chIndex = champion2;
    else if (num > 10) chIndex = champion3;
    else chIndex = champion4;
    
    players[i].reset(players[chIndex].nn, true);
    num--;
  }
  for (Meteor m : meteors) {
    m.reset();
  }
}

void circle(PVector position, float radius) {
  ellipse(position.x, position.y, radius, radius);
}
