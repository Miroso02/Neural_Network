Meteor[] meteors = new Meteor[20];
PlayerController pc = new PlayerController(45, 5);
final float METEOR_SPEED = 4;
final float PLAYER_SPEED = 10;

void setup() {
  size(displayWidth, displayHeight);
  //size(720, 1280);
  noStroke();
  textSize(60);
  
  for (int i = 0; i < meteors.length; i++) {
    meteors[i] = new Meteor();
  }
}

void draw() {
  background(155);
  fill(0);
  text("Gen " + pc.generation, 100, 100);
  
  if (!mousePressed) {
    simulate();
    displaySimulation();
    if (pc.allDead()) createNewGeneration();
    return;
  }
  
  while(!pc.allDead()) {
    simulate();
  }
  createNewGeneration();
}

void simulate() {
  for (Meteor m : meteors) {
    m.move();
    if (a.isTouchingBorder()) a.reset();
  }
  pc.simulate();
}
void displaySimulation() {
  for (Meteor m : meteors) {
    m.display();
  }
  pc.display();
}
void createNewGeneration() {
  pc.createNewGen();
  for (Meteor m : meteors) {
    m.reset();
  }
}

void circle(PVector position, float radius) {
  ellipse(position.x, position.y, radius, radius);
}
