/*
 * SoundTriggeredShape.pde
 *
 * Charles Ford, 2020
 */

import ddf.minim.analysis.*;

final float min_freq = 20.0;
final float max_freq = 20000.0;

public class SoundTriggeredShape extends ShapeFlyer
{
  // Data
  float frequency;
  float amplitude;
  float amp_span;

  SoundTriggeredShape() {
    // implicit super();
    frequency = min_freq + random(max_freq - min_freq);
    amplitude = 2.0 + random(30.0);
    amp_span = 0.5 + random(0.5);
  }

  SoundTriggeredShape(
    int x0,
    int y0,
    int extentX,
    int extentY,
    float spacing
  ) {
    super(x0, y0, extentX, extentY, spacing);
    frequency = min_freq + random(max_freq - min_freq);
    amplitude = 2.0 + random(30.0);
    amp_span = 0.5 + random(0.5);
  }

  void check(FFT fftLog) {
    float curAmp = fftLog.getFreq(frequency);
    if (amplitude * (1.0 - amp_span) < curAmp && curAmp < amplitude * (1.0 + amp_span)) {
      this.reset();
    }
  }
}
