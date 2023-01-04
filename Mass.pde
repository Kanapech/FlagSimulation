class Mass {
  PVector index;
  float mass;
  PVector pos;
  PVector vel;
  PVector forces;
  boolean fixed;

  Mass() {
    index = new PVector(0, 0);
    mass = 0;
    pos = new PVector(0, 0, 0);
    vel = new PVector(0, 0, 0);
    forces = new PVector(0, 0, 0);
    fixed = false;
  }
  
  void setForces(PVector f){
    if(fixed == false)
      forces = f;
  }

  void display() {
    //fill(255);
    //ellipse(pos.x, pos.y, mass, mass);
  }
}
