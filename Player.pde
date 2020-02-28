class Player extends PObject{
  float x, y; //position
  float spX, spY; //speed X and speed Y
  boolean dead; //he's a trash!
  boolean isChampion; //green colour

  int numOfPar;
  int best = 1; //record for THIS player
  int lifeTime = 0; //time from birth
  
  NeuronNetwork nn;

  public Player() {
    dead = false;
    isChampion = false;
    x = width / 2;
    y = height / 2;
    
    numOfPar=12;
    nn =new NeuronNetwork(numOfPar, 12, 2);
    // input(12) → 2 → output(2)
  }

  void display()
  {
    fill(255, 0, 0); //red – default
    if(isChampion)
      fill(0,255,0); //green – was the best in last gen.
    if(best==highscore)
      fill(0,0,255); //blue – last who've beaten the highscore
    ellipse(x, y, 10, 10); //size is fixed
  }

  void move()
  { 
    x+=spX;
    y+=spY;
  }

  void think() //the hardest stuff
  {
    //parameters
    float[] parameters=new float[numOfPar];
    for(float a:parameters) a=0;
    
    parameters[0]=x-width; //dist to right wall
    parameters[1]=x;       //dist to left wall
    parameters[2]=y-height;//dist to down wall
    parameters[3]=y;       //dist to down wall
    
    for(Meteor a:meteors)
    {
      float distX=x-a.position.x;
      float distY=y-a.position.y;
      float dist=sqrt(sq(distX)+sq(distY))-a.size/2-5;
      int numInMass=0;
      
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
    float spXc=results[0],spYc=results[1];
    
    final float speed = 10;

    spX=spXc*speed/(abs(spXc)+abs(spYc));
    spY=spYc*speed/(abs(spXc)+abs(spYc));
  }

  void die()
  {
    if(!dead)
    {
      lifeTime++; //you still exist!
    }
    
    for (Meteor a : meteors)
    {  //if meteor is touching you
      if (sq(x-a.position.x)+sq(y-a.position.y)<sq(a.size/2+5))
      {
        setRec();
      }
    }
    if (x<0 || x>width || y<0 || y>height)
    {  //or if wall is touching you
      setRec();
    }
  }

  void reset(NeuronNetwork master, boolean change)
  {
    //genes – parameters of the best players
    //change – false for the best players
    dead=false;  //reborn
    x=width/2;
    y=height/2;

    if (change) //if you're not the chosen one
    {
      nn.newLayers(master);
    }
    lifeTime=0;
  }
  
  void setRec()
  {
    if(!dead)
    {
      dead=true;
      if(lifeTime>best)
        best=lifeTime;
      isChampion=false;
    }
  }
}
