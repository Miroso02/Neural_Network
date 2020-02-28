class Player extends PObject{
  boolean dead;
  boolean isChampion;

  int numOfPar;
  int best = 1;
  int lifeTime = 0;

  NeuronNetwork nn;

  public Player() {
    dead = false;
    isChampion = false;
    position = new PVector(width / 2, height / 2);
    velocity = new PVector(0, 0);

    size = 10;
    col = color(255, 0, 0);

    numOfPar = 12;
    nn = new NeuronNetwork(numOfPar, 12, 2);
    // input(12) → 2 → output(2)
  }

  void display() {
    col = color(255, 0, 0);
    if (isChampion) col = color(0, 255, 0);
    if (best == highscore) col = color(0, 0, 255);

    fill(col);
    circle(position, size);
  }

  void think() {
    float[] parameters=new float[numOfPar];

    // Parameters 0-3 are distances to the walls
    parameters[0] = position.x - width; //dist to right wall
    parameters[1] = position.x;         //dist to left wall
    parameters[2] = position.y - height;//dist to down wall
    parameters[3] = position.y;         //dist to down wall

    final float maxDist = sqrt(sq(width) + sq(height));
    // Parameters 4-11 are distances to the nearest meteors in 8 directions
    for (int i = 4; i < 12; i++) {
      parameters[i] = maxDist;
    }
    for (int i = 0; i < 4; i++) { // 4 different lines for directions
      for (Meteor meteor : meteors) {
        float distX = meteor.position.x - position.x;
        float distY = meteor.position.y - position.y;
        if (distY * cos(i * QUARTER_PI) - distX * sin(i * QUARTER_PI) < meteor.size) {
          float dist = (distTo(meteor) - (meteor.size + this.size) / 2) / maxDist;
          int num = distY < 0 ? i + 4 : i + 8;
          if (parameters[num] > dist) parameters[num] = dist;
        }
      }
    }

    float[] results = nn.countValue(parameters);
    final float speed = 10;
    velocity = new PVector(results[0], results[1]).normalize().mult(speed);
  }

  void update() {
    if (!dead) {
      lifeTime++;
    }

    for (Meteor a : meteors) {
      if (this.isTouching(a)) {
        setRec();
        return;
      }
    }
    if (isTouchingBorder()) setRec();
  }

  void reset(NeuronNetwork master, boolean change) {
    dead = false;
    position.set(width / 2, height / 2);

    if (change) nn.newLayers(master);
    lifeTime = 0;
  }

  void setRec() {
    if (!dead) {
      dead = true;
      if (lifeTime > best) best = lifeTime;
      isChampion = false;
    }
  }
}
