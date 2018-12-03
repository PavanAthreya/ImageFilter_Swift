//: Playground - noun: a place where people can play

//Pavan Athreya
//MS - Electrical Engineering
//University of Southern California

//https://www.linkedin.com/in/pavanathreya/

// A ImageFilter Class is created to handle different kind of filters
// Please refer the class from Sources Folder in the playground

// View the images fter every statement by clicking on the show result to the right of every link

//Each filter method created a deep copy of the image pixel data structure and applies the filter

import UIKit

let image = UIImage(named: "sample")!
image.size

//Initialise the filter using the image
let filter = ImageFilter(image:image)
//Average pixel value should be calculated before applyig filters
filter.averagePixel

//Function to reduce the alpha of the image
filter.ReduceBrightness(byPercentage: 25)

//Function to enhance the red pixels of the image
filter.ApplyRedFilter()

//Function to enhance the blue pixels of the image
filter.ApplyBlueFilter()

//Function to enhance the green pixels of the image
filter.ApplyGreenFilter()

//Function to convert RGB to grayscale based on statistical color conversion
filter.ImageToAdvancedGrayScale()

//Function to convert RGB to grayscale based on 3 color averages
filter.ImageToNormalGrayScale()

//Function to invert the pixels
filter.InvertImage()
