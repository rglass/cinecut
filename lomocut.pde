/*
  author: Roman Glass
  data: 2012-11-07
  
  Coded the instructions from 
  http://www.lomography.com/magazine/tipster/2011/11/11/are-you-a-programmer-help-us-write-a-software-for-turning-lomokino-scans-into-movies
*/

PImage[] xs;

String[] files() {
  java.io.File folder = new java.io.File(dataPath(""));
  return folder.list();
}

void setup() {
  for (String file : files()) {
    PImage img = loadImage(file);
    float[] as = new float[img.height];
    float b = 0;
    for (int y = 0; y < img.height; y++) {
      float a = 0;
      for (int x = 0; x < img.width; x++) {
        a += brightness(img.get(x, y));
      }
      as[y] = a / img.width;
      b += as[y];
    }
    // Picture average.
    b = b / img.height;
    float thres = b / 3;
    int start = 0;
    boolean isSaved = false;
    for (int i = 0; i < as.length; i++) {
      if (as[i] < thres) {
        if (isSaved == false) {
          println(start + ", " + i);
          size(img.width, i - start);
          PImage cropped = img.get(0, start, img.width, i);
          image(cropped, 0, 0);
          save(file + "_" + i + ".jpg");
          isSaved = true;
        }
      } 
      else {
        if (isSaved == true) {
          start = i;
          isSaved = false;
        }
      }
    }
  }
}

