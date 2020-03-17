public class PObject {
  PVector position;
  PVector velocity;
  int size;
  color col;
  
  //----------------- Main methods ----------------------
  
  public void move() {
    position.add(velocity);
  }
  public void display() {
    fill(col);
    circle(position, size);
  }
  
  //----------------- Info methods ----------------------
  
  boolean isTouchingBorder() {
    return (abs(position.x - width / 2) > width / 2 ||
            abs(position.y - height / 2) > height / 2);
  }
  boolean isTouching(PObject obj) {
    return distTo(obj) < (this.size + obj.size) / 2;
  }
  float distTo(PObject obj) {
    return PVector.dist(this.position, obj.position);
  }
}