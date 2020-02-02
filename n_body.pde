/* CONFIGURATION */
static final int   WIDTH      = 950;
static final int   HEIGHT     = 720;
static final int   NUM_BODIES = 8;
static final float G          = 50.0;
static final float MAX_RADIUS = 40.0;
static final float MIN_RADIUS = 10.0;

/* N BODY SIM CLASS AND DATA STRUCTURES */
class Body {
  private PVector vel;  // in m/s
  private PVector pos;
  private float radius; // in m
  private color c;
  
  public float mass;    // in kg
  
  public Body(float x_pos, float y_pos, float radius) {
    pos = new PVector(x_pos, y_pos);
    vel = new PVector(random(-10, 10), random(-10, 10));
    
    this.radius = radius;
    this.mass = radius * radius * PI;
    this.c = color(random(90, 255), random(90, 255), random(90, 255));
  }
  
  public void update_velocity(PVector force) {
    vel.add(PVector.mult(force.div(mass), 1.0 / frameRate));
  }
  
  public void update_pos() {
    pos.add(PVector.mult(vel, 1.0 / frameRate));
  }
  
  public void draw() {
    stroke(this.c);
    circle(pos.x, pos.y, radius);
  }
}

class NBodySim {
  ArrayList<Body> bodies;
  
  public NBodySim(int num_bodies) {
    bodies = new ArrayList<Body>();
    
    for (int i = 0; i < num_bodies; i++) {
      bodies.add(new Body(random(WIDTH), random(HEIGHT), random(MIN_RADIUS, MAX_RADIUS)));
    }
  }
  
  public void tick() {
    PVector force_total = new PVector(); // Total force of gravity on a given body this tick
    PVector force_vec = new PVector();
    
    float distance;
    float force_grav;
    
    ArrayList<Body> other_bodies;
    Body body;
    Body other_body;
    
    // Compute forces on bodies
    for (int i = 0; i < bodies.size(); i++) {
      body = bodies.get(i);
      
      // Reset force total
      force_total.setMag(0);
      
      // Get all other bodies
      other_bodies = new ArrayList<Body>(bodies);
      other_bodies.remove(body);
      
      // Compute total force due to gravity
      for (int k = 0; k < other_bodies.size(); k++) {
        other_body = other_bodies.get(k); //<>//
        
        // F = G * ((m1*m2) / r^3) * R
        distance = PVector.dist(body.pos, other_body.pos);
        force_grav = G * ((body.mass * other_body.mass) / pow(distance, 3));
        
        force_vec.x = other_body.pos.x - body.pos.x;
        force_vec.y = other_body.pos.y - body.pos.y;
        force_vec.mult(force_grav);
        
        force_total.add(force_vec);
      }
      
      body.update_velocity(force_total);
    }
    
    // Update body positions
    for (int i = 0; i < bodies.size(); i++) {
      bodies.get(i).update_pos();
    }
  }
  
  public void draw() {
    for (int i = 0; i < bodies.size(); i++) {
      bodies.get(i).draw();
    }
  }
}

PFont f;
NBodySim sim;

void settings() {
  size(WIDTH, HEIGHT, P2D);
}

void setup() {
  f = createFont("Monospaced", 16, false);
  
  ellipseMode(RADIUS);
  noFill();
  stroke(255);
  strokeWeight(4);
  
  sim = new NBodySim(NUM_BODIES);
}

void draw() {
  background(0);
  
  sim.tick();
  sim.draw();
  
  text(frameRate, 10, 10);
}
