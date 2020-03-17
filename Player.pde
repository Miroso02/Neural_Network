class Player extends PObject {
  boolean dead;
  boolean isChampion;

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

    nn = new NeuronNetwork(8, 2);
    // input(8) → output(2)
  }
  
  void display() {
    col = color(255, 0, 0);
    if (isChampion) col = color(0, 255, 0);
    if (best == highscore) col = color(0, 0, 255);

    fill(col);
    circle(position, size);
  }

  void think() {
    final int numOfPar = 8;
    float[] parameters = new float[numOfPar];

    for (Meteor a : meteors) { 
      float distX = position.x - a.position.x; 
      float distY = position.y - a.position.y; 
      int numInMass = 0; 
      if (abs(distX) < (a.size + size) / 2) {
        numInMass = distY > 0 ? 0 : 1;
      } else if (abs(distY) < (a.size + size) / 2) { 
        numInMass = distX < 0 ? 2 : 3;
      } else if (abs(distX - distY) < a.size / sqrt(2)) { //diagonals  
        numInMass = distX < 0 ? 4 : 5;
      } else if (abs(distX + distY) < a.size / sqrt(2)) { 
        numInMass = distX < 0 ? 6 : 7;
      } 
      if (numInMass != 0) { 
        float dist = sqrt(sq(distX) + sq(distY)) - (a.size + size) / 2; 
        if (dist < parameters[numInMass] || parameters[numInMass] == 0) { 
          parameters[numInMass] = dist;
        }
      }
    }
    for (int i = 0 ; i < 8; i++) {
      if (parameters[i] == 0) {
        switch (i) {
          case 0: parameters[i] = position.y; break;
          case 1: parameters[i] = height - position.y; break;
          case 2: parameters[i] = width - position.x; break;
          case 3: parameters[i] = position.x; break;
          case 4: parameters[i] = min(width - position.x, position.y) * sqrt(2); break;
          case 5: parameters[i] = min(position.x, height - position.y) * sqrt(2); break;
          case 6: parameters[i] = min(width - position.x, height - position.y) * sqrt(2); break;
          case 7: parameters[i] = min(position.x, position.y) * sqrt(2); break;
        }
      }
    }
    
    float[] results = nn.countValue(parameters);
    velocity = new PVector(results[0], results[1]).normalize().mult(PLAYER_SPEED);
  }

  void update() {
    if (!dead) {
      lifeTime++;
    }

    for (Meteor meteor : meteors) {
      if (this.isTouching(meteor)) {
        setRec();
        return;
      }
    }
    if (this.isTouchingBorder()) setRec();
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
