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

  void display()
  {
    col = color(255, 0, 0);
    if (isChampion) col = color(0, 255, 0);
    if (best == highscore) col = color(0, 0, 255);
   
    fill(col);
    circle(position, size);
  }

  void think() {
    float[] parameters=new float[numOfPar];
    
    parameters[0] = position.x - width; //dist to right wall
    parameters[1] = position.x;         //dist to left wall
    parameters[2] = position.y - height;//dist to down wall
    parameters[3] = position.y;         //dist to down wall
    
    for (Meteor a : meteors) {
      float distX = position.x - a.position.x;
      float distY = position.y - a.position.y;
      float dist = sqrt(sq(distX) + sq(distY)) - a.size / 2 - 5;
      int numInMass = 0;
      
      if(abs(distX)<a.size)//vertical x=0
      {
        numInMass=5;       //up
        if(distY<0)        //down
          numInMass=4;
      }
      else if(abs(distY)<a.size)//horisontal y=0
      {
        numInMass=7;           //left
        if(distX<0)             //right
          numInMass=6;
      }
      else if(abs(abs(distX)-abs(distY))<a.size/1.4142) //diagonals
      {
        if(distX*distY>0)//diagonal y=-x
        {
          numInMass=9;  //up-left
          if(distX<0)    //down-right
            numInMass=8;
        }
        else             //diagonal.y=x
        {
          numInMass=11;  //up-right
          if(distX<0)    //down-left
            numInMass=10;
        }
      }
      
      if(numInMass!=0)
      {
        if(abs(dist)<abs(parameters[numInMass])  
         || parameters[numInMass]==0)
        {
          parameters[numInMass]=dist;//distance
        }
      }
    }

    float[] results=nn.countValue(parameters);
    final float speed = 10;
    velocity = new PVector(results[0], results[1]).normalize().mult(speed);
  }

  void die() {
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
