import java.util.Arrays;
import java.util.Random;

int[][] grid = {
  {0, 0, 0, 0}, 
  {0, 0, 0, 0}, 
  {0, 0, 0, 0}, 
  {0, 0, 0, 0}
};
int[][] textSize = new int[4][4];
color[][] cellColor = new color[4][4];
Random randomGenerator = new Random();
PImage leftImg, rightImg, upImg, downImg;
PImage currImg;

void setup() {
  size(400, 400);

  leftImg = scaleImg(loadImage("data/left.png"), 0.25);
  rightImg = scaleImg(loadImage("data/right.png"), 0.25);
  upImg = scaleImg(loadImage("data/up.png"), 0.25);
  downImg = scaleImg(loadImage("data/down.png"), 0.25);
  currImg = rightImg;

  addToGrid(4);
}

void draw() {
  background(255);
  strokeWeight(2);
  stroke(100);
  textAlign(CENTER);

  updateTextSize();
  updateCellColor();

  showGrid();
  showOverlay();

  //saveFrame("frames/#####.png");
}

void updateCellColor() {
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) 
    {
      int val = grid[i][j];
      cellColor[i][j] = getColor(val);
    }
  }
}

void updateTextSize() {
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) 
    {
      if (textSize[i][j] < 36 ) {
        textSize[i][j] += 2;
      }
    }
  }
}

void showGrid() {
  for (int i = 0; i < 4; i++) {
    int x = i * 100;
    for (int j = 0; j < 4; j++) {
      int y = j * 100;
      int val = grid[i][j];
      fill(cellColor[i][j]);
      rect(x, y, 100, 100);
      if (val != 0) {
        fill(0);
        textSize(textSize[i][j]);
        text(val + "", x + 50, y + 60);
      }
    }
  }
}

color getColor(int val) {
  colorMode(HSB);
  float pow = log(val) / log(2);
  return color(pow * 255.0 / 11.0, 255, 255);
}

boolean addToGrid(int n) {
  for (int i = 0; i < n; i++) {
    int[] ij = randomEmptySpot();
    if (ij == null) return false;
    else {
      grid[ij[0]][ij[1]] = 2 * (randomGenerator.nextInt(2) + 1);
      textSize[ij[0]][ij[1]] = 0;
    }
  }

  return true;
}

int countEmpty() {
  int count = 0;
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (grid[i][j] == 0) count++;
    }
  }

  return count;
}

int[] randomEmptySpot() {

  ArrayList<int[]> emptyCellList = new ArrayList<int[]>();

  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (grid[i][j] == 0) emptyCellList.add(new int[]{i, j});
    }
  }

  if (emptyCellList.size() == 0) return null;

  int[] ij = emptyCellList.get(randomGenerator.nextInt(emptyCellList.size()));

  return ij;
}

void update(int[] vals) {
  shift(vals);

  for (int i = 0; i < vals.length - 1; i++) {
    if (vals[i] == vals[i+1]) {
      vals[i] *= 2;
      vals[i+1] = 0;
    }
  }

  shift(vals);
}

void shift(int[] vals) {
  int numOfVals = 0;
  for (int i = 0; i < vals.length; i++) {
    if (vals[i] != 0) numOfVals++;
  }

  int[] nonZeros = new int[numOfVals];
  int index = 0;
  for (int i = 0; i < vals.length; i++) {
    if (vals[i] != 0) {
      nonZeros[index] = vals[i];
      vals[i] = 0;
      index++;
    }
  }

  for (int i = 0; i < nonZeros.length; i++) {
    vals[i] = nonZeros[i];
  }
}

int[][] copyGrid() {
  int[][] gridCopy = new int[4][4];
  for (int j = 0; j < 4; j++) {
    for (int i = 0; i < 4; i++) {
      gridCopy[i][j] = grid[i][j];
    }
  }
  return gridCopy;
}

boolean hasGridChanged(int[][] newGrid) {
  for (int j = 0; j < 4; j++) {
    for (int i = 0; i < 4; i++) {
      if (newGrid[i][j] != grid[i][j]) return true;
    }
  }

  return false;
}

boolean leftSwipe() {
  setDir(Dir.LEFT);
  int[][] gridCopy = copyGrid();
  for (int j = 0; j < 4; j++) {
    int[] vals = new int[4];
    for (int i = 0; i < 4; i++) {
      vals[i] = grid[i][j];
    }

    update(vals);
    for (int i = 0; i < 4; i++) {
      grid[i][j] = vals[i];
    }
  }

  return hasGridChanged(gridCopy);
}

boolean rightSwipe() {
  setDir(Dir.RIGHT);
  int[][] gridCopy = copyGrid();
  for (int j = 0; j < 4; j++) {
    int[] vals = new int[4];
    for (int i = 0; i < 4; i++) {
      vals[3 - i] = grid[i][j];
    }

    update(vals);
    for (int i = 0; i < 4; i++) {
      grid[3 - i][j] = vals[i];
    }
  }
  return hasGridChanged(gridCopy);
}

boolean upSwipe() {
  setDir(Dir.UP);
  int[][] gridCopy = copyGrid();
  for (int i = 0; i < 4; i++) {
    int[] vals = new int[4];
    for (int j = 0; j < 4; j++) {
      vals[j] = grid[i][j];
    }

    update(vals);
    for (int j = 0; j < 4; j++) {
      grid[i][j] = vals[j];
    }
  }
  return hasGridChanged(gridCopy);
}

boolean downSwipe() {
  setDir(Dir.DOWN);
  int[][] gridCopy = copyGrid();
  for (int i = 0; i < 4; i++) {
    int[] vals = new int[4];
    for (int j = 0; j < 4; j++) {
      vals[3 - j] = grid[i][j];
    }

    update(vals);
    for (int j = 0; j < 4; j++) {
      grid[i][3 - j] = vals[j];
    }
  }
  return hasGridChanged(gridCopy);
}

void keyPressed() {
  boolean changed = false;
  if (keyCode == LEFT) changed = leftSwipe() || changed;
  if (keyCode == RIGHT) changed = rightSwipe() || changed;
  if (keyCode == UP) changed = upSwipe() || changed;
  if (keyCode == DOWN) changed = downSwipe() || changed;

  if (changed) {
    addToGrid(1);
  }

  if (countEmpty() == 0) {
    print("Game Over!!");
  }
}

PImage scaleImg(PImage img, float scl) {
  float w = img.width * scl;
  float h = img.height * scl;
  img.resize(int(w), int(h));

  return img;
}