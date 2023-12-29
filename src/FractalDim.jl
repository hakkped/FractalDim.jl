@doc "Segment/binarize images and compute generalized fractal dimension using Rényi entropy. The package should give approximately the same results as box-counting."
module FractalDim
using Images, Plots, FractalDimensions, StateSpaceSets, ComplexityMeasures, ImageView

export analysis
export compute_fractal_dim
export pm_analysis

include("analysis.jl")
include("compute_fractal_dim.jl")
include("pm_analysis.jl")


end
