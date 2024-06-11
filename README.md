# FractalDim

[![Build Status](https://github.com/hakkped/FractalDim.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/hakkped/FractalDim.jl/actions/workflows/CI.yml?query=branch%3Amain)

Compute fractal dimension of images of porous media using the package [FractalDimensions.jl](https://github.com/JuliaDynamics/FractalDimensions.jl). The package binarizes a given image using [ImageBinarization.jl](https://github.com/JuliaImages/ImageBinarization.jl). To do analysis on e.g. a image series (for instance a entire folder of images), one can run the relevant function in a loop.

The code is based on a Matlab-script by [Marcel Moura](https://www.mn.uio.no/fysikk/english/people/aca/mnmoura/) for the course [FYS4420/FYS9420](https://www.uio.no/studier/emner/matnat/fys/FYS9420/index-eng.html) at UiO.


# Installation
At the Julia-prompt, add the package using `import Pkg; Pkg.add(url="https://github.com/hakkped/FractalDim.jl.git")`

Alternatively, add the package using Julia's inbuilt package prompt by pressing `]` at the Julia-prompt, and do `add https://github.com/hakkped/FractalDim.jl.git`.

THe package has been testet with Julia-version 1.9. If there are problems, one can try to revert to this version. 

# Usage
The package provides a single function, , with additional keyword arguments for determining what the function computes and the output. The keyword arguments are as follows:
`image::Matrix{RGB{N0f8}}` : The image to be binarized.
`crop::`: The area of the image to use. Note that [ImageView.jl](https://github.com/JuliaImages/ImageView.jl) has easy methods of viewing images and ways of finding the coordinates of the crop-region.
`compute_frac_dim = true`: Compute generalized fractal dimension
`plot_results = true`: Plot the original and binarized images, in addition to the 
``


Note that you are free to modify the code and use it in your own work. In this case, I ask that you credit either Moura (lee link above) or this package (use the Github-link).
