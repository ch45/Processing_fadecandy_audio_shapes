/**
 * Processing_fadecandy_audio_shapes.pde
 *
 * Charles Ford, 2020
 */

import java.util.ArrayDeque;

OPC opc;

final int boxesAcross = 2;
final int boxesDown = 2;
final int ledsAcross = 8;
final int ledsDown = 8;
// initialized in setup()
float spacing;
int x0;
int y0;

// for exit, fade in and fade out
int exitTimer = 0;

// Start a FIFO stack
ArrayList<ShapeFlyer> flyerStack = new ArrayList<ShapeFlyer>();

public void setup() {

  apply_cmdline_args();

  size(720, 480, P2D);

  colorMode(HSB, 360, 100, 100);

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  spacing = (float)min(height / (boxesDown * ledsDown + 1), width / (boxesAcross * ledsAcross + 1));
  x0 = (int)(width - spacing * (boxesAcross * ledsAcross - 1)) / 2;
  y0 = (int)(height - spacing * (boxesDown * ledsDown - 1)) / 2;

  final int boxCentre = (int)((ledsAcross - 1) / 2.0 * spacing); // probably using the centre in the ledGrid8x8 method
  int ledCount = 0;
  for (int y = 0; y < boxesDown; y++) {
    for (int x = 0; x < boxesAcross; x++) {
      opc.ledGrid8x8(ledCount, x0 + spacing * x * ledsAcross + boxCentre, y0 + spacing * y * ledsDown + boxCentre, spacing, 0, false, false);
      ledCount += ledsAcross * ledsDown;
    }
  }

  // ShapeFlyer one = new ShapeFlyer(598.0, 478.0, 24, 36, 4, 280, -0.8, -0.8);
  for (int i = 0; i < 10; i++) {
    ShapeFlyer one = new ShapeFlyer(x0, y0, (int)(x0 + spacing * boxesAcross * ledsAcross), (int)(y0 + spacing * boxesDown * ledsDown), spacing);
    flyerStack.add(one);
  }
}

public void draw() {

  int count = 0;
  background(0);

  for (ShapeFlyer cur: flyerStack) {
    if (cur.valid()) {
      cur.draw();
      cur.move();
      count++;
    }
  }

  if (count == 0) {
    for (ShapeFlyer cur: flyerStack) {
      cur.reset();
    }
  }

  check_exit();
}

void apply_cmdline_args() {

  if (args == null) {
    return;
  }

  for (String exp: args) {
    String[] comp = exp.split("=");
    switch (comp[0]) {
    case "exit":
      exitTimer = parseInt(comp[1], 10);
      println("exit after " + exitTimer + "s");
      break;
    }
  }
}

void check_exit() {

  if (exitTimer == 0) { // skip if not run from cmd line
    return;
  }

  int m = millis();
  if (m / 1000 >= exitTimer) {
    exit();
  }
}
