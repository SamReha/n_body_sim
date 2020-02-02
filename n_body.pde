/* CONFIGURATION */
static final int     WIDTH         = 950;    // screen width (pixels)
static final int     HEIGHT        = 720;    // screen height (pixels)
static final int     NUM_BODIES    = 200;      // how many discrete bodies in the sim?
static final float   G             = 50.0;   // gravitational constant
static final float   MAX_RADIUS    = 30.0;   // maximum radius (in pixels) of body
static final float   MIN_RADIUS    = 1.0;   // minimum radius (in pixels) of body
static final float   MAX_START_VEL = 100.0;  // maximum starting velocity of body
static final boolean ENABLE_SUN    = true;   // true: place "sun" at center of screen. false: no sun
static final float   SUN_MASS      = 20000.0; // mass of sun, if enabled

/* GLOBAL VARIABLES */
PGraphics pg;
PFont f;
NBodySim sim;
float last_draw_time; //<>//

/* PROCESSING ENTRY POINTS */
void settings() {
  size(WIDTH, HEIGHT);
}

void setup() {
  pg = createGraphics(WIDTH, HEIGHT);
  f = createFont("Monospaced", 16, false);
  sim = new NBodySim(NUM_BODIES);
  
  pg.ellipseMode(RADIUS);
  frameRate(999); // Effectively unlimit framerate
  last_draw_time = 0.0;
}

void draw() {
  sim.tick();
  
  // Don't draw faster that 60 fps (1/60 second ~= 16.6 millis)
  if ((millis() - last_draw_time) > 17) {
    last_draw_time = millis();
    
    pg.beginDraw();
    pg.background(0);
    pg.strokeWeight(4);
    pg.noFill();
    
    sim.draw();
    
    pg.text(frameRate, 10, 10);
    pg.endDraw();
    image(pg, 0, 0);
  }
}
