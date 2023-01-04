class Spring {
  Mass mass1;
  Mass mass2;
  float stiffness;
  float baseLength;

  Spring() {
    mass1 = null;
    mass2 = null;
    stiffness = 0;
    baseLength = 0;
  }

  void display() {
    stroke(255, 0, 0);
    line(mass1.pos.x, mass1.pos.y, mass1.pos.z, mass2.pos.x, mass2.pos.y, mass2.pos.z);
  }
}
