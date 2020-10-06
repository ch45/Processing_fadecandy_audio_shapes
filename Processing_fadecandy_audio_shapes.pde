/**
 * Processing_fadecandy_audio_shapes.pde
 *
 * Charles Ford, 2020
 */

import java.util.ArrayDeque;

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer sound; // mp3 input
// AudioInput sound; // microphone input
FFT fftLog;
final int maxAmplitude = 255;

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
ArrayList<SoundTriggeredShape> flyerStack = new ArrayList<SoundTriggeredShape>();

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

  minim = new Minim(this);

  sound = minim.loadFile("083_trippy-ringysnarebeat-3bars.mp3", 1024);  // mp3 input
  // sound = minim.getLineIn(Minim.MONO, 1024); // microphone input

  // loop the file
  sound.loop(); // mp3 input

  // create an FFT object for calculating logarithmically spaced averages
  fftLog = new FFT(sound.bufferSize(), sound.sampleRate()); // may fail if the microphone device is already in use!

  fftLog.logAverages(22, 3);
  // fftLog.logAverages(11, 1);

  // ShapeFlyer one = new ShapeFlyer(598.0, 478.0, 24, 36, 4, 280, -0.8, -0.8);
  for (int i = 0; i < 10; i++) {
    SoundTriggeredShape one = new SoundTriggeredShape(x0, y0, (int)(x0 + spacing * boxesAcross * ledsAcross), (int)(y0 + spacing * boxesDown * ledsDown), spacing);
    flyerStack.add(one);
  }
}

public void draw() {

  fftLog.forward(sound.mix);

  background(0);

  for (SoundTriggeredShape cur: flyerStack) {

    cur.check(fftLog);

    if (cur.valid()) {
      cur.draw();
      cur.move();
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
