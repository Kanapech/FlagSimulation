class Triangle {
  Mass mass1;
  Mass mass2;
  Mass mass3;

  Triangle() {
    mass1 = null;
    mass2 = null;
    mass3 = null;
  }
  
  Triangle(Mass m1, Mass m2, Mass m3) {
    mass1 = m1;
    mass2 = m2;
    mass3 = m3;
  }

  void display() {
    stroke(255);
    //noFill();

    beginShape();
    vertex(mass1.pos.x, mass1.pos.y, mass1.pos.z);
    vertex(mass2.pos.x, mass2.pos.y, mass2.pos.z);
    vertex(mass3.pos.x, mass3.pos.y, mass3.pos.z);
    endShape();
  }
}
