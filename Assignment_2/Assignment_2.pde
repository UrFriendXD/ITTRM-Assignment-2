import controlP5.*;

Boid barry;
ArrayList<Boid> boids;
ArrayList<Boid> removedBoids;
ArrayList<Avoid> avoids;

float globalScale = .91;
float eraseRadius = 20;
String tool = "boids";

// boid control
float maxSpeed;
float friendRadius;
float crowdRadius;
float avoidRadius;
float coheseRadius;

boolean option_friend = true;
boolean option_crowd = true;
boolean option_avoid = true;
boolean option_noise = true;
boolean option_cohese = true;

// gui crap
int messageTimer = 0;
String messageText = "";

// table and time stuff
Table data;
int index = 1; //row of the table
int x = 0;
int y = 0;
boolean isOverUI = false;
String time = " ";


//UI stuff
ControlP5 cp5;

void setup () {
  size(1024, 576);
  textSize(16);
  data = loadTable("peopleCount.csv", "csv" );
  time = data.getString(index, 0);
  recalculateConstants();
  boids = new ArrayList<Boid>();
  removedBoids = new ArrayList<Boid>();
  avoids = new ArrayList<Avoid>();
  y = data.getInt(index, 1);
  for (int i = 0; i < y; i++) {
    boids.add(new Boid(random(width), random(height)));
  }
  cp5 = new ControlP5(this);
  cp5.addButton("Next").setValue(0).setPosition(800, 400).setSize(100, 100);
  cp5.addButton("Previous").setValue(0).setPosition(125, 400).setSize(100, 100);
  setupCircle();
}

//method for button "Next"
public void Next() {
  index++;
  println(index);
  changeTime();
}

//method for button "Previous"
public void Previous() {
  index--;
  time = data.getString(index, 0);
  println(time);
  changeTime();
}
void changeTime() {
  x = data.getInt(index, 0);
  y = data.getInt(index, 1);
  float difference = y - boids.size();
  println(difference);
  if (difference > 0) {
    for (int i = 0; i < difference; i++) {
      Boid first = new Boid(random(width), random(height));
      boids.add(first);
    }
  } else if (difference < 0) {
    for (int i = 0; i > difference; i--) {
      erase();
    }
  }
}

// haha
void recalculateConstants () {
  maxSpeed = 2.1 * globalScale;
  friendRadius = 60 * globalScale;
  crowdRadius = (friendRadius / 1.3);
  avoidRadius = 90 * globalScale;
  coheseRadius = friendRadius;
}

void setupCircle() {
  avoids = new ArrayList<Avoid>();
  for (int x = 0; x < 50; x+= 1) {
    float dir = (x / 50.0) * TWO_PI;
    avoids.add(new Avoid(width * 0.5 + cos(dir) * height*.4, height * 0.5 + sin(dir)*height*.4));
  }
}


void draw () {
  noStroke();
  colorMode(HSB);
  fill(0, 100);
  rect(0, 0, width, height);

  for (int i = 0; i <boids.size(); i++) {
    Boid current = boids.get(i);
    if (current.isDead) 
    {
      boids.remove(i);
      removedBoids.remove(current);
    } 
    current.go();
    current.draw();
  }

  //for (int i = 0; i <removedBoids.size(); i++) {
  //  Boid current = boids.get(i);
  //  if (current.isDead) 
  //  {
  //    boids.remove(i);
  //  } 
  //  current.go();
  //  current.draw();
  //}

  for (int i = 0; i <avoids.size(); i++) {
    Avoid current = avoids.get(i);
    current.go();
    current.draw();
  }

  if (messageTimer > 0) {
    messageTimer -= 1;
  }
  drawGUI();
}

void keyPressed () {
  recalculateConstants();
}

void drawGUI() {
  if (messageTimer > 0) {
    fill((min(30, messageTimer) / 30.0) * 255.0);
    text(messageText, 10, height - 20);
  }
  text(time, 100, 100);
}

String s(int count) {
  return (count != 1) ? "s" : "";
}

String on(boolean in) {
  return in ? "on" : "off";
}

void mousePressed () {
  // If mouse is over UI, prevents boid spawning
  if (cp5.isMouseOver()) {
    return;
  }
  // Adds boid on left, remove random on right
  switch (mouseButton) {
  case LEFT:
    Boid newBoid = new Boid(mouseX, mouseY);
    boids.add(newBoid);
    message(boids.size() + " Total Boid" + s(boids.size()));
    break;
  case RIGHT:
    erase();
    break;
  }
}

// Sets a random boid to be deleted
void erase () {
  if (boids.size() > 0 ) 
  {
    int index = int(random(boids.size()));
    Boid randomBoid = boids.get(index);
    if (randomBoid.toBeRemoved == false && !removedBoids.contains(randomBoid))
    {
      randomBoid.toBeRemoved = true;
      removedBoids.add(randomBoid);
    }
  }
}

void drawText (String s, float x, float y) {
  fill(0);
  text(s, x, y);
  fill(200);
  text(s, x-1, y-1);
}


void message (String in) {
  messageText = in;
  messageTimer = (int) frameRate * 3;
}
