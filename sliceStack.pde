/*
 Copyright (c) 2015 Alex Jacque <alexjacque.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

/*
  Just a note:
  All images should be the same size with this script,
  elsewise you'll run into some strange output, if not 
  straight up errors.
*/

// Import File class, needed for getting list of files in a directory
import java.io.File;

// variable setup

String path; // to hold the path of folder containing this PDE
String imageFolder; // folder of images to use
String[] filenames; // array of file names in our imageFolder
float numImages; // number of images in imageFolder
/* numImages is a float because ceil(), used further down, 
   needs something with a decimel point to work right */

PImage img;
int imageWidth;
int imageHeight;

boolean vertical; // direction
int sliceWidthVertical;
int sliceWidthHorizontal;
int sliceStartX; // if vertical
int sliceStartY; // if horizontal

void setup() {
  // file variables
  path = sketchPath; 
  imageFolder = "/_images";
  path = sketchPath + imageFolder;
  filenames = listFileNames(path);
  numImages = filenames.length;
  println("total number of images: " + numImages);
  
  // lets load the first image in our array of images and get the width and height
  img=loadImage(path + "/" + filenames[0]);
  imageWidth = img.width;
  imageHeight = img.height;
  println("canvas width " + imageWidth);
  println("canvas height " + imageHeight);

  /*
    sliceWidth uses ceil() to round up to the nearest pixel
    to determine how to best fill the canvas with slices,
    this can lead to the last slice running off the side of
    the canvas, but that's probably better than the slices 
    not completely filling the canvas space.
  */

  sliceWidthVertical = ceil(imageWidth / numImages); // if slicing vertically
  sliceWidthHorizontal = ceil(imageHeight / numImages); // if slicing horizontally
  println("slice width vert: " + sliceWidthVertical);
  println("slice width horiz: " + sliceWidthHorizontal);
  println("- - -");
  
  vertical = true; // vertical or horizontal
  
  size(imageWidth,imageHeight);
  noLoop();
}

void draw() {
  PImage tempImage; // setup a temporary empty image variable
  
  for (int i=0; i<numImages; i++) {
    println("loaded: " + filenames[i]); // log the image name that has been loaded from our array
    tempImage = loadImage(path + "/" + filenames[i]); // load the "i" image in the array
    
    if (vertical == true) { // vetical
      sliceStartX = i * sliceWidthVertical; // x coord of our slice starting corner
      PImage slicedImage = tempImage.get(sliceStartX,0,sliceWidthVertical,imageHeight); // get slice
      image(slicedImage,sliceStartX,0); // place image
    } else if (vertical == false) { // horizontal
      sliceStartY = i * sliceWidthHorizontal; // y coord of our slice starting corner
      PImage slicedImage = tempImage.get(0,sliceStartY,imageWidth,sliceWidthHorizontal);
      image(slicedImage,0,sliceStartY); // place image
    }
  }
  
  save("output.png"); // save final composition
}


// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    String finalNames[] = new String[names.length-1];
    int k = 0;
    for(int i = 0; i < names.length; i++){
      if(!names[i].equals(".DS_Store")){
        finalNames[k] = names[i];
        k++;
      }
    }
    return finalNames;
  } else {
    // If it's not a directory
    return null;
  }
}
