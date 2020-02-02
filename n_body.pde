/* CONFIGURATION */
static final int     WIDTH         = 950;    // screen width (pixels)
static final int     HEIGHT        = 720;    // screen height (pixels)
static final int     NUM_BODIES    = 500;      // how many discrete bodies in the sim?
static final float   G             = 50.0;   // gravitational constant
static final float   MAX_RADIUS    = 40.0;   // maximum radius (in pixels) of body
static final float   MIN_RADIUS    = 10.0;   // minimum radius (in pixels) of body
static final float   MAX_START_VEL = 100.0;  // maximum starting velocity of body
static final boolean ENABLE_SUN    = true;   // true: place "sun" at center of screen. false: no sun
static final float   SUN_MASS      = 9000.0; // mass of sun, if enabled

/* GLOBAL VARIABLES */
PGraphics pg;
PFont f;
NBodySim sim;

/* N BODY SIM CLASS AND DATA STRUCTURES */
class Body {
  protected PVector vel;  // in pixels/s
  protected PVector pos;  // in pixels
  protected float radius; // in pixels
  protected color c;
  
  public float mass;    // in kg
  
  public Body() {
    vel = new PVector(0.0, 0.0);
    pos = new PVector(0.0, 0.0);
    radius = 0;
    c = color(0, 0, 0);
    mass = 0.0;
  }
  
  public Body(float x_pos, float y_pos, float radius) {
    pos = new PVector(x_pos, y_pos);
    vel = new PVector(random(-MAX_START_VEL, MAX_START_VEL), random(-MAX_START_VEL, MAX_START_VEL));
    
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
    pg.stroke(this.c);
    pg.noFill();
    pg.circle(pos.x, pos.y, radius);
  }
}

class Sun extends Body {
  public Sun() {
    pos = new PVector(WIDTH / 2, HEIGHT / 2);
    vel = new PVector(0.0, 0.0);
    
    this.mass = SUN_MASS;
    this.radius = sqrt(SUN_MASS) / PI;
    this.c = color(255, 255, 0);
  }
  public void update_velocity(PVector force) { };
}

class NBodySim {
  ArrayList<Body> bodies;
  
  public NBodySim(int num_bodies) {
    bodies = new ArrayList<Body>();
    
    for (int i = 0; i < num_bodies; i++) {
      bodies.add(new Body(random(WIDTH), random(HEIGHT), random(MIN_RADIUS, MAX_RADIUS)));
    }
    
    if (ENABLE_SUN) bodies.add(new Sun());
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
        
        // Compute R
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

/* PROCESSING ENTRY POINTS */
void settings() {
  size(WIDTH, HEIGHT, P2D);
}

void setup() {
  pg = createGraphics(WIDTH, HEIGHT);
  f = createFont("Monospaced", 16, false);
  sim = new NBodySim(NUM_BODIES);
  
  pg.ellipseMode(RADIUS);
}

void draw() {
  pg.beginDraw();
  pg.background(0);
  pg.strokeWeight(4);
  
  sim.tick();
  sim.draw();
  
  pg.text(frameRate, 10, 10);
  pg.endDraw();
  image(pg, 0, 0);
}
