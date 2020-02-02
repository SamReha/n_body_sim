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
NBodySim sim; //<>//

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
