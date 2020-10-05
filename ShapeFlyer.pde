/*
 * ShapeFlyer.pde
 *
 * Charles Ford, 2020
 */

final float min_increment = 2.0;

public class ShapeFlyer
{
  // Data
  float curX;
  float curY;
  float incX;
  float incY;
  int initX;
  int initY;
  int dimX;
  int dimY;
  int hue;
  int weight;

  ShapeFlyer(
    int initX,
    int initY,
    int dimX,
    int dimY,
    int weight,
    int hue,
    float incX,
    float incY
  ) {
    this.initX = initX;
    this.initY = initY;
    this.curX = initX;
    this.curY = initY;
    this.dimX = dimX;
    this.dimY = dimY;
    this.weight = weight;
    this.hue = hue;
    this.incX = incX;
    this.incY = incY;
  }

  ShapeFlyer(
    int x0,
    int y0,
    int extentX,
    int extentY,
    float spacing
  ) {
    int initX = (int)(x0 + (extentX - x0) / 4 + random((extentX - x0) / 2));
    int initY = (int)(y0 + (extentY - y0) / 4 + random((extentY - y0) / 2));
    int dimX = (int)(spacing * (1.5 + random(3.0)));
    int dimY = (int)(spacing * (1.5 + random(3.0)));
    int weight = (int)(spacing * (0.5 + random(1.0)));
    int hue = 40 * (int)(random(9.0));
    float centreX = (extentX + x0) / 2;
    float centreY = (extentY + y0) / 2;

    float mag = sqrt(sq(initX - centreX) + sq(initY - centreY));

    float rand = min_increment + random(5.0);
    float incX = (initX - centreX) / mag * rand;
    float incY = (initY - centreY) / mag * rand;

    if (abs(incX) < min_increment && abs(incY) < min_increment) {
      println("we fixed up the minimum increment");
      if (abs(incX) < abs(incY)) {
        incX = min_increment;
      } else {
        incY = min_increment;
      }
    }

    this.initX = initX;
    this.initY = initY;
    this.curX = initX;
    this.curY = initY;
    this.dimX = dimX;
    this.dimY = dimY;
    this.weight = weight;
    this.hue = hue;
    this.incX = incX;
    this.incY = incY;
  }

  void move() {
    curX += incX;
    curY += incY;
  }

  void draw() {
    noFill();
    stroke(hue, 100, 100);
    strokeWeight(weight);
    rect(curX - dimX / 2, curY - dimY / 2, dimX, dimY);
  }

  boolean valid() {
    return (curX + dimX / 2 >= 0 && curX - dimX / 2 < width && curY + dimY / 2 >= 0 && curY - dimY / 2 < height);
  }

  void reset() {
    curX = initX;
    curY = initY;
  }

}
