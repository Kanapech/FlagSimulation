class MassSpring { //<>// //<>//
  int nbMass;
  int nbSpring;
  int nbTriangle;
  float airMassFriction;
  float airTriangleFriction;
  ArrayList<Mass> masses;
  ArrayList<Spring> springs;
  ArrayList<Triangle> triangles;

  MassSpring(int nbMasses, int nbSprings, int nbTriangles) {
    nbMass = nbMasses;
    nbSpring = nbSprings;
    nbTriangle = nbTriangles;

    airMassFriction = 0;
    airTriangleFriction = 0;

    masses = new ArrayList();
    springs = new ArrayList();
    triangles = new ArrayList();
  }

  MassSpring() {
    airMassFriction = 0;
    airTriangleFriction = 0;

    masses = new ArrayList();
    springs = new ArrayList();
    triangles = new ArrayList();
  }

  void display() {
    if (dispSpring) {
      for (Spring s : springs) {
        s.display();
      }
    }

    if (dispTriangle) {
      for (Triangle t : triangles) {
        t.display();
      }
    }
  }

  PVector genWind() {
    PVector wind = new PVector(0, 0, 0);
    float vx = 8.0;
    float vz = 0;

    vx += random(-2, 2);
    vz += random(-1, 1);

    if (vx < 2.0)
      vx = 2.0;
    if (vx > 5.0)
      vx = 5.0;
    if (vz < -3.0)
      vz=-3.0;
    if (vz > 3.0)
      vz=3.0;

    wind = new PVector(vx, 0.0, vz);

    return wind;
  }

  void eulerIntegration() {
    PVector a = new PVector();

    for (int i=0; i<masses.size(); i++) {
      a = PVector.div(masses.get(i).forces, masses.get(i).mass);
      masses.get(i).vel.add(PVector.mult(a, dt));
      masses.get(i).pos.add(PVector.mult(masses.get(i).vel, dt));
    }
  }

  void calcForces() {
    PVector gravite = new PVector(0, 9.8, 0);

    for (int i = 0; i<masses.size(); i++) {
      masses.get(i).setForces(PVector.mult(gravite, masses.get(i).mass));
      masses.get(i).forces.add(PVector.mult(masses.get(i).vel, -Kad));
    }

    for (int i = 0; i<springs.size(); i++) {
      float kS = springs.get(i).stiffness;
      float lenij = PVector.sub(springs.get(i).mass2.pos, springs.get(i).mass1.pos).mag();
      PVector vnorm = PVector.sub(springs.get(i).mass2.pos, springs.get(i).mass1.pos).normalize();

      PVector friction = PVector.mult(vnorm, kS*(lenij-springs.get(i).baseLength));

      springs.get(i).mass1.setForces(PVector.add(springs.get(i).mass1.forces, friction));
      springs.get(i).mass2.setForces(PVector.sub(springs.get(i).mass2.forces, friction));
    }

    for (int i = 0; i<triangles.size(); i++) {
      PVector friction;
      PVector n;
      PVector vSurf;
      PVector v1, v2;

      PVector windV = genWind().mult(wind?windStrength:0);


      v1 = PVector.sub(triangles.get(i).mass2.pos, triangles.get(i).mass1.pos);
      v2 = PVector.sub(triangles.get(i).mass3.pos, triangles.get(i).mass1.pos);

      n = v1.copy().cross(v2).normalize();

      vSurf = PVector.div(PVector.add(PVector.add(triangles.get(i).mass1.vel, triangles.get(i).mass2.vel), triangles.get(i).mass3.vel), 3);
      friction = PVector.div(PVector.mult(n, PVector.dot(n, PVector.sub(windV, vSurf))), 3);


      triangles.get(i).mass1.setForces(PVector.add(triangles.get(i).mass1.forces, friction));
      triangles.get(i).mass2.setForces(PVector.add(triangles.get(i).mass2.forces, friction));
      triangles.get(i).mass3.setForces(PVector.add(triangles.get(i).mass3.forces, friction));

      //println(i, triangles.get(i).mass1.forces, triangles.get(i).mass2.forces, triangles.get(i).mass3.forces);
    }
  }

  void update() {
    calcForces();
    eulerIntegration();
  }
}
