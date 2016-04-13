# Linearisation



## Overview
A set of functions and example script for linearising remote sensing data created with JPEG images. The code can be applied to individual non-linear images with 3 bands such as `.JPEG` photos or orthomosaics e.g. `.TIFF` files. 

## Features
* Applies coefficients from a second order polynomial equation to transform DN values
* Works on all three bands (R,G,B)
* Also projects the transformed data to a desired coordinate system
* Outputs `.TIFF` with stacked reflectance bands (rounded to 2 decimal places) 
