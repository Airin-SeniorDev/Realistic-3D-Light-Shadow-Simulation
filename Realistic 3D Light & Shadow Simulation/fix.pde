import controlP5.*;
import peasy.*;

PeasyCam cam;
PVector lightPos;
color lightColor;

ControlP5 cp5;
float lx = 200, ly = 100, lz = 300;
int r = 255, g = 255, b = 200;
boolean showRay = true;
String shapeType = "Sphere";

boolean leftPressed = false, rightPressed = false, upPressed = false, downPressed = false;
boolean wPressed = false, sPressed = false, aPressed = false, dPressed = false;

void setup() {
  size(1000, 700, P3D);
  surface.setTitle(" Realistic 3D Light & Shadow Simulation");
  cam = new PeasyCam(this, 500);

  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);

  cp5.addSlider("lx").setPosition(20, 20).setRange(-400, 400).setValue(lx).setLabel("Light X");
  cp5.addSlider("ly").setPosition(20, 50).setRange(-400, 400).setValue(ly).setLabel("Light Y");
  cp5.addSlider("lz").setPosition(20, 80).setRange(-400, 400).setValue(lz).setLabel("Light Z");

  cp5.addSlider("r").setPosition(20, 130).setRange(0, 255).setValue(r).setLabel("Light R");
  cp5.addSlider("g").setPosition(20, 160).setRange(0, 255).setValue(g).setLabel("Light G");
  cp5.addSlider("b").setPosition(20, 190).setRange(0, 255).setValue(b).setLabel("Light B");

  cp5.addToggle("showRay").setPosition(20, 240).setSize(20, 20).setValue(true).setLabel("Show Light Ray");

  cp5.addScrollableList("shapeType")
     .setPosition(20, 280)
     .setSize(140, 70)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(new String[] {"Sphere", "Box", "Torus"})
     .setValue(0)
     .setLabel("Object Type");
}

void draw() {
  background(120, 160, 220);
  ambientLight(10, 10, 10);
  updateLightFromKeyboard();
  lightPos = new PVector(lx, ly, lz);
  lightColor = color(r, g, b);
  pointLight(r, g, b, lightPos.x, lightPos.y, lightPos.z);

  hint(DISABLE_DEPTH_TEST);
  cp5.draw();
  hint(ENABLE_DEPTH_TEST);

  drawScene();
}

void drawScene() {
  pushMatrix();
  translate(0, 150, 0);
  fill(80);
  box(800, 10, 800);
  popMatrix();

  pushMatrix();
  applyShadowMatrix(new PVector(0, 150, 0), lightPos);
  fill(0, 100);
  noStroke();
  drawShape(shapeType);
  popMatrix();

  pushMatrix();
  translate(0, 0, 0);
  specular(r, g, b);
  shininess(80);
  fill(100, 180, 255);
  drawShape(shapeType);
  popMatrix();

  pushMatrix();
  translate(0, 151, 0);
  scale(1, -1, 1);
  drawReflection(shapeType);
  popMatrix();

  if (showRay) {
    stroke(lightColor);
    strokeWeight(2);
    line(lightPos.x, lightPos.y, lightPos.z, 0, 0, 0);
  }

  // จุดแสง (แก้ให้สีตรงตาม lightColor โดยไม่โดนแสงรอบข้าง)
  pushStyle();
  noLights();
  noStroke();
  pushMatrix();
  translate(lightPos.x, lightPos.y, lightPos.z);
  fill(lightColor);
  sphere(10);
  popMatrix();
  popStyle();
}

void drawShape(String shapeType) {
  switch (shapeType) {
    case "Box":
      box(140);
      break;
    case "Torus":
      drawTorus(60, 20, 64, 32);
      break;
    default:
      sphere(100);
  }
}

void drawReflection(String shapeType) {
  PVector normal = new PVector(0, -1, 0);
  PVector lightDir = PVector.sub(lightPos, new PVector(0, 0, 0)).normalize();
  float brightness = max(0.05, normal.dot(lightDir));
  fill(100 * brightness, 180 * brightness, 255 * brightness, 180 * brightness);
  noStroke();
  drawShape(shapeType);
}

void drawTorus(float r1, float r2, int seg1, int seg2) {
  for (int i = 0; i < seg1; i++) {
    float theta = TWO_PI * i / seg1;
    float nextTheta = TWO_PI * (i + 1) / seg1;
    for (int j = 0; j < seg2; j++) {
      float phi = TWO_PI * j / seg2;
      float nextPhi = TWO_PI * (j + 1) / seg2;
      beginShape(QUADS);
      for (int k = 0; k < 4; k++) {
        float t = (k == 0 || k == 3) ? theta : nextTheta;
        float p = (k == 0 || k == 1) ? phi : nextPhi;
        float x = (r1 + r2 * cos(p)) * cos(t);
        float y = (r1 + r2 * cos(p)) * sin(t);
        float z = r2 * sin(p);
        vertex(x, y, z);
      }
      endShape();
    }
  }
}
//****//
void applyShadowMatrix(PVector planePoint, PVector light) {
  float[] shadowMat = new float[16];
  float a = 0, b = 1, c = 0, d = -planePoint.y;
  float dot = a * light.x + b * light.y + c * light.z + d;

  shadowMat[0]  = dot - a * light.x;
  shadowMat[4]  = -a * light.y;
  shadowMat[8]  = -a * light.z;
  shadowMat[12] = -a;

  shadowMat[1]  = -b * light.x;
  shadowMat[5]  = dot - b * light.y;
  shadowMat[9]  = -b * light.z;
  shadowMat[13] = -b;

  shadowMat[2]  = -c * light.x;
  shadowMat[6]  = -c * light.y;
  shadowMat[10] = dot - c * light.z;
  shadowMat[14] = -c;

  shadowMat[3]  = -d * light.x;
  shadowMat[7]  = -d * light.y;
  shadowMat[11] = -d * light.z;
  shadowMat[15] = dot;

  applyMatrix(
    shadowMat[0], shadowMat[1], shadowMat[2], shadowMat[3],
    shadowMat[4], shadowMat[5], shadowMat[6], shadowMat[7],
    shadowMat[8], shadowMat[9], shadowMat[10], shadowMat[11],
    shadowMat[12], shadowMat[13], shadowMat[14], shadowMat[15]
  );
}

void controlEvent(ControlEvent e) {
  if (e.isFrom("shapeType")) {
    shapeType = e.getStringValue();
  }
}

void updateLightFromKeyboard() {
  if (leftPressed || aPressed) lx -= 2;
  if (rightPressed || dPressed) lx += 2;
  if (upPressed) lz -= 2;
  if (downPressed) lz += 2;
  if (wPressed) ly -= 2;
  if (sPressed) ly += 2;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) leftPressed = true;
    if (keyCode == RIGHT) rightPressed = true;
    if (keyCode == UP) upPressed = true;
    if (keyCode == DOWN) downPressed = true;
  } else {
    if (key == 'w') wPressed = true;
    if (key == 's') sPressed = true;
    if (key == 'a') aPressed = true;
    if (key == 'd') dPressed = true;
    if (key == '1') shapeType = "Sphere";
    if (key == '2') shapeType = "Box";
    if (key == '3') shapeType = "Torus";
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT) leftPressed = false;
    if (keyCode == RIGHT) rightPressed = false;
    if (keyCode == UP) upPressed = false;
    if (keyCode == DOWN) downPressed = false;
  } else {
    if (key == 'w') wPressed = false;
    if (key == 's') sPressed = false;
    if (key == 'a') aPressed = false;
    if (key == 'd') dPressed = false;
  }
}
