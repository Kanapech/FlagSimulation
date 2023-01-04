boolean dispSpring = false; //<>// //<>// //<>// //<>// //<>//
boolean dispTriangle = true;
boolean wind = true;

float dt;

float m = 3;
float Kas = 150;
float Kac = 5;
float Kad = 5;

int windStrength = 80;
float airMassFr = 0.01;
float airTriangleFr = 5.5;

int nbMassWidth = 20;
int nbMassHeight = 16;

PVector topLeftCorner = new PVector(30, 30, 0);
int offset = 20;

int totalMasses = nbMassWidth * nbMassHeight;
int totalSprings = (nbMassHeight-1)*nbMassWidth
  + (nbMassHeight*(nbMassWidth-1))
  + (nbMassHeight-2)*nbMassWidth
  + (nbMassHeight*(nbMassWidth-2))
  + (nbMassHeight-1)*(nbMassWidth-1)
  + (nbMassHeight-1)*(nbMassWidth-1);

int totalTriangles = 2*((nbMassHeight-1)*(nbMassWidth-1));

MassSpring lattice = new MassSpring();

void setup() {
  size(800, 500, P3D);
  surface.setLocation(100, 100);
  createLattice();
  frameRate(144);
  dt = 1.0/frameRate;
}

void draw() {
  background(0);
  lights();
  lattice.display();
  lattice.update();

  text("M : afficher maillage", 600, 110);
  text("T : afficher triangles", 600, 125);
  text("W : activer vent", 600, 140);
  text("A/E : Augmenter/Diminuer vent", 600, 155);
  text("Force du vent : "+windStrength, 600, 170);
}

void createLattice() {
  Mass[][] masses = new Mass[nbMassWidth][nbMassHeight];

  //Création des masses
  for (int j = 0; j<nbMassHeight; j++) {
    for (int i = 0; i<nbMassWidth; i++) {

      PVector ptemp = new PVector((offset*i)+topLeftCorner.x, (offset*j)+topLeftCorner.y, topLeftCorner.z);
      masses[i][j] = new Mass();
      masses[i][j].pos = ptemp;
      masses[i][j].mass = m;
      masses[i][j].index = new PVector(i, j);

      lattice.masses.add(masses[i][j]);
    }
  }

  //Masses des coins
  masses[0][nbMassHeight-1].fixed = true;
  masses[0][nbMassHeight-2].fixed = true;
  masses[0][0].fixed = true;
  masses[0][1].fixed = true;

  //Création des ressorts
  Spring tempR = new Spring();

  //Ressorts primaires largeur
  for (int j = 0; j<nbMassHeight; j++) {
    for (int i = 0; i<nbMassWidth-1; i++) {

      tempR.mass1 = masses[i][j];
      tempR.mass2 = masses[i+1][j];
      tempR.stiffness = Kas;
      tempR.baseLength = offset;

      lattice.springs.add(tempR);
      tempR = new Spring();
    }
  }

  //Ressorts secondaires largeur
  for (int j = 0; j<nbMassHeight; j++) {
    for (int i = 0; i<nbMassWidth-2; i++) {

      tempR.mass1 = masses[i][j];
      tempR.mass2 = masses[i+2][j];
      tempR.stiffness = Kac;
      tempR.baseLength = 2.0*offset;

      lattice.springs.add(tempR);
      tempR = new Spring();
    }
  }

  //Ressorts primaires hauteur
  for (int j = 0; j<nbMassHeight-1; j++) {
    for (int i = 0; i<nbMassWidth; i++) {

      if (i == 0) { //Drapeau au niveau de la tige
        tempR.mass1 = masses[i][j];
        tempR.mass2 = masses[i][j+1];
        tempR.stiffness = Kas;
        tempR.baseLength = 0.7*offset;
        lattice.springs.add(tempR);
      } else {
        tempR.mass1 = masses[i][j];
        tempR.mass2 = masses[i][j+1];
        tempR.stiffness = Kas;
        tempR.baseLength = offset;

        lattice.springs.add(tempR);
      }
      tempR = new Spring();
    }
  }

  //Ressorts secondaires hauteur
  for (int j = 0; j<nbMassHeight-2; j++) {
    for (int i = 0; i<nbMassWidth; i++) {
      tempR.mass1 = masses[i][j];
      tempR.mass2 = masses[i][j+2];
      tempR.stiffness = Kac;
      tempR.baseLength = 2.0*offset;

      lattice.springs.add(tempR);
      tempR = new Spring();
    }
  }

  //Ressorts primaires diagonale
  for (int j = 0; j<nbMassHeight-1; j++) {
    for (int i = 0; i<nbMassWidth-1; i++) {
      tempR.mass1 = masses[i][j];
      tempR.mass2 = masses[i+1][j+1];
      tempR.stiffness = Kad;
      tempR.baseLength = (float) Math.sqrt(2.0)*offset;

      lattice.springs.add(tempR);
      tempR = new Spring();
    }
  }

  //Ressorts secondaires diagonale
  for (int j = 0; j<nbMassHeight-1; j++) {
    for (int i = 0; i<nbMassWidth-1; i++) {

      tempR.mass1 = masses[i][j+1];
      tempR.mass2 = masses[i+1][j];
      tempR.stiffness = Kad;
      tempR.baseLength = (float) Math.sqrt(2.0)*offset;

      lattice.springs.add(tempR);
      tempR = new Spring();
    }
  }

  //Création des triangles
  Triangle t1 = new Triangle();
  Triangle t2 = new Triangle();
  for (int j=0; j<nbMassHeight-1; j++) {
    for (int i=0; i<nbMassWidth-1; i++) {
      t1.mass1 = masses[i][j];
      t1.mass2 = masses[i+1][j];
      t1.mass3 = masses[i+1][j+1];

      t2.mass1 = masses[i][j];
      t2.mass2 = masses[i+1][j+1];
      t2.mass3 = masses[i][j+1];

      lattice.triangles.add(t1);
      lattice.triangles.add(t2);

      t1 = new Triangle();
      t2 = new Triangle();
    }
  }

  lattice.airMassFriction = airMassFr;
  lattice.airTriangleFriction = airTriangleFr;
}

void keyPressed() {
  if (key == 'w') wind = !wind;
  if (key == 'm') dispSpring = !dispSpring;
  if (key == 't') dispTriangle = !dispTriangle;
  if (key == 'a') windStrength -= 5;
  if (key == 'e') windStrength += 5;
}
