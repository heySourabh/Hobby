/**
 Author:
 Sourabh Bhat (https://spbhat.in)
 Description:
 Processing sketch for a bouncing ball 
 with elasticity and wall friction.
 */

float x = 100;
float y = 100;
float ballDia = 50;

float speedx = 5;
float speedy = 0;
float accelx = 0.0;
float accely = 0.1;

float elasticity = 0.9;
float friction = 0.1;

void setup() {
  size(800, 600);
}

void draw() {
  //background(255);
  fill(255, 75);
  rect(0, 0, width, height);
  fill(255, 0, 0);
  noStroke();
  speedx += accelx;
  speedy += accely;
  x += speedx;
  y += speedy;
  ellipse(x, y, ballDia, ballDia);
  if (x < ballDia/2) {
    speedx *= -elasticity;
    speedy *= (1.0 - friction);
    x = ballDia/2;
  }
  if ((x + ballDia/2) > width) {
    speedx *= -elasticity;
    speedy *= (1.0 - friction);
    x = width - ballDia/2;
  }
  if (y < ballDia/2) {
    speedy *= -elasticity;
    speedx *= (1.0 - friction);
    y = ballDia/2;
  }
  if ((y + ballDia/2) > height) {
    speedy *= -elasticity;
    speedx *= (1.0 - friction);
    y = height - ballDia/2;
  }

  //saveFrame("frames/frame_#####.png");

  if (abs(speedx * speedy) < 1e-6) {
    print("Stopped!");
    noLoop();
  }
}