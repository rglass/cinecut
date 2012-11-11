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
    if (file.equals(".DS_Store")) {
      continue;
    }
    PImage img = loadImage(file);
    float[] as = new float[img.height];

    // Calculate the average brightness of the frame.
    float b = 0;
    for (int y = 0; y < img.height; y++) {
      float a = 0;
      for (int x = 0; x < img.width; x++) {
        a += brightness(img.get(x, y));
      }
      as[y] = a / img.width;
      b += as[y];
    }
    b = b / img.height;
    
    /*
      TODO: This should be automated.
      Now the procedure is generally like this:
      (1) Use a threshold like b / 3.
      Output should be 4 picture per frame/file.
      (2) Copy the generated files to a "cuted" folder.
      Delete these files in the "data" folder. Delete all generated files.
      (3) Decrement the threshold by halfing it.
      Redo the program.
    */
    
    float thres = b / 1.025;
    
    int start = 0;
    boolean isSaved = false;
    for (int i = 0; i < as.length; i++) {
      if (as[i] < thres) {
        if (isSaved == false) {
          if (img.width == 0 || (i - start) == 0) {
            continue;
          }
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
    // Last frame.
    if (img.height - start > 0) {
      size(img.width, img.height - start);
      PImage cropped = img.get(0, start, img.width, img.height);
      image(cropped, 0, 0);
      save(file + "_last.jpg");
    }
  }
}

