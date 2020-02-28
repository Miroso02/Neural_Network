Meteor[] meteors = new Meteor[20]; //obstacles
Player[] players = new Player[45]; //AIs
//ArrayList<Player> players = new ArrayList<Player>();
int generation;
int score;
int highscore; 

void setup() {
  size(displayWidth, displayHeight);
  noStroke();
  textSize(60);
  generation = 1;
  score = 0;
  highscore = 0;

  for (int i = 0; i < meteors.length; i++) {
    meteors[i] = new Meteor();
  }

  for (int i = 0; i < 45; i++) {
    //players.add(new Player());
    players[i] = new Player();
  }
}

void draw() {
  boolean allDead = false;
  if (mousePressed) {
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
    p.die();
  }
}
void displaySimulation() {
  background(155);
  for (Meteor a : meteors) {
    a.display();
  }
  
  fill(0);
  text("Gen " + generation, 100, 100);
  text("Score " + score, width - 300, 100);
  text("Best " + highscore, width - 300, 200);
  
  for (Player p : players) {
    if (!p.dead) {
      p.display();
    }
  }
}

void createNewGeneration() {
  println("Gen " + generation + "; score: " + score + "; highscore: " + highscore);
  generation++; //go to next generation
  if (highscore < score) highscore = score; //if highscore is beaten
  score = 0; //starts from the begining

  int champion = 0; 
  int champion2 = 0; //indexes of the best 
  int champion3 = 0; //players in last game
  int champion4 = 0;
  for (int i = 0; i<players.length; i++) {
    if (players[champion].lifeTime < players[i].lifeTime) {
      champion = i; //finding the best 1
    }
  }
  for (int i=0; i<players.length; i++)
  {
    if (players[champion2].lifeTime<players[i].lifeTime)
    {
      if (i!=champion)
        champion2=i; //finding the best 2
    }
  }
  for (int i=0; i<players.length; i++)
  {
    if (players[champion3].lifeTime<players[i].lifeTime)
    {
      if (i!=champion && i!=champion2)
        champion3=i; //finding the best 3
    }
  }
  for (int i=0; i<players.length; i++)
  {
    if (players[champion4].lifeTime<players[i].lifeTime)
    {
      if (i!=champion && i!=champion2 && i!=champion3)
        champion4=i; //finding the best 4
    }
  }

  int num=40;
  for (int i=0; i<players.length; i++) 
  { //creating champion's children
    if (i==champion || i==champion2 || i==champion3 ||
      i==champion4 || players[i].best==highscore)
    { //if the player is champion or have beaten a highscore
      //we leave him without changes
      players[i].reset(players[champion].nn, false);
      players[i].isChampion=true; //colour parameter
      continue;
    }
    if (num>30)
    {
      players[i].reset(players[champion].nn, true);
    } else if (num>20)
    {
      players[i].reset(players[champion2].nn, true);
    } else if (num>10)
    {
      players[i].reset(players[champion3].nn, true);
    } else
    {
      players[i].reset(players[champion4].nn, true);
    }
    num--;
    //look Player → reset()
  }
  for (Meteor m : meteors)
  {
    m.reset(); //meteors return to borders
  }
}

void circle(PVector position, float radius) {
  ellipse(position.x, position.y, radius, radius);
}
