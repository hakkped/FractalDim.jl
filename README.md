# FractalDim

[![Build Status](https://github.com/hakkped/FractalDim.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/hakkped/FractalDim.jl/actions/workflows/CI.yml?query=branch%3Amain)

Compute fractal dimension of images of porous media using the package [FractalDimensions.jl](https://github.com/JuliaDynamics/FractalDimensions.jl). The package binarizes a given image using [ImageBinarization.jl](https://github.com/JuliaImages/ImageBinarization.jl). To do analysis on e.g. a image series (for instance a entire folder of images), one can run the relevant function in a loop.

The code is based on a Matlab-script by [Marcel Moura](https://www.mn.uio.no/fysikk/english/people/aca/mnmoura/) for the course [FYS4420/FYS9420](https://www.uio.no/studier/emner/matnat/fys/FYS9420/index-eng.html) at UiO. This Julia-package is provided as a alternative starting point for performing the calculations in relevant experiments in said course. 

The functions in the package serves as a starting point, and can be extended or modified. You are free to modify the code and use it in your own work. In this case, I ask that you credit either Moura (see link above) or this package (use the Github-link).


# Installation
At the Julia-prompt, add the package using `import Pkg; Pkg.add(url="https://github.com/hakkped/FractalDim.jl.git")`

Alternatively, add the package using Julia's inbuilt package prompt by pressing `]` at the Julia-prompt, and do `add https://github.com/hakkped/FractalDim.jl.git`.

The package has been testet with Julia-version 1.10. If there are problems, one can try to revert to this version.

# Usage
The package provides a handful of functions to compute the fractal dimension of an image, and general processing such as binarization, cleaning up specs etc. 

To start, one simply loads an image using `load`-function in the `Images`-package. This can be used as a input to most of the functions in the package. To determine a region of interest in the image, one can e.g. open the image using the `ImageView`-package, and mark a region to find the dimensions. One could add some code to automate this selection, or simply save the dimensions as a variable. 


Quick summary of functions:
- `compute_fractal_dim` computes the fractal dimension of the fluid mass and the front. 
- `analysis` is a unfinished function which can be extended if you want to visualize the results in a single function.
- `pm_analysis` binarizes and segments the image, along with performing some simple cleanup (diameter closing). It is recommended to have a look in the documentation for the different image processing functions being used to get e better idea of the procedure. 
- `pm_front_only` isolates the front in the input image. 
- `compute_cluster_size_dist` computes the cluster size distribution in the input image. The input image should be cropped to the region of interest.


# Visualization
The package only performs analysis of the images, so one is free to use any means of visualizing the results. [ImageView](https://github.com/JuliaImages/ImageView.jl) is fast and simple, since it has easy methods of viewing images and ways of finding the coordinates of the crop-region, but there are many more packages that does the same.


