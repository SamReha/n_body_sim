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
    
    Body body;
    Body other_body;
    
    // Compute forces on bodies
    for (int i = 0; i < bodies.size(); i++) {
      body = bodies.get(i);
      
      // Reset force total
      force_total.setMag(0);
      
      // Compute total force due to gravity
      for (int k = 0; k < bodies.size(); k++) {
        other_body = bodies.get(k);
        
        // Don't try to compute your gravitational attraction to yourself...
        if (other_body == body) continue;
        
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
