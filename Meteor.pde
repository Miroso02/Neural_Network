class Meteor extends PObject {
  public Meteor() {
    velocity = new PVector(0, 0);
    position = new PVector(0, 0);
    reset();
  }
  
  void display() {
    fill(0, 100);
    circle(position, size);
  }
  
  void reset() {
    float spX = random(METEOR_SPEED);
    float spY = sqrt(sq(METEOR_SPEED) - sq(spX));
    velocity.set(spX, spY);
    position.set(0, height / 2);
    
    int border = (int) random(4);
    int a = (int) random(2);
    
    switch (border) {
      case 0:     //left
        position.set(0, random(height));
        if (a == 0) velocity.y = -velocity.y;
        break;
        
      case 1:     //right
        position.set(width, random(height));
        velocity.x = -velocity.x;
        if(a == 0) velocity.y = -velocity.y;
        break;
        
      case 2:     //up
        position.set(random(width), 0);
        if(a == 0) velocity.x = -velocity.x;
        break;
        
      case 3:     //down
        position.set(random(width), height);
        velocity.y = -velocity.y;
        if(a == 0) velocity.x = -velocity.x;
        break;
    }
    size = 100;
  }
}