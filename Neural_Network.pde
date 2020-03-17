Meteor[] meteors = new Meteor[20]; //obstacles
PlayerController pc = new PlayerController(45, 5);
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
}

void draw() {
  background(155);
  fill(0);
  text("Gen " + generation, 100, 100);
  
  if (!mousePressed) {
    simulate();
    displaySimulation();
    if (pc.allDead()) createNewGeneration();
    return;
  }
  while(!pc.allDead()) {
    simulate();
  }

  if (pc.allDead()) createNewGeneration();
}

void simulate() {
  score++;
  for (Meteor a : meteors) {
    a.move();
    if (a.isTouchingBorder()) a.reset();
  }
  pc.simulate();
}
void displaySimulation() {
  for (Meteor a : meteors) {
    a.display();
  }
  pc.display();
}

void createNewGeneration() {
  generation++;
  if (highscore < score) highscore = score;
  score = 0;
  
  pc.createNewGen();
  
  for (Meteor m : meteors) {
    m.reset();
  }
}

void circle(PVector position, float radius) {
  ellipse(position.x, position.y, radius, radius);
}
