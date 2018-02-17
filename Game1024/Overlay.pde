enum Dir {
  LEFT, RIGHT, UP, DOWN
}

float overlayOpacity = 0.0;

void setDir(Dir dir){
  overlayOpacity = 100.0;
  if(dir == Dir.LEFT) currImg = leftImg;
  if(dir == Dir.RIGHT) currImg = rightImg;
  if(dir == Dir.UP) currImg = upImg;
  if(dir == Dir.DOWN) currImg = downImg;
}

void showOverlay() {
  tint(255, overlayOpacity);
  image(currImg, (width - currImg.width) / 2, (height - currImg.height) / 2);
  overlayOpacity -= 2;
}