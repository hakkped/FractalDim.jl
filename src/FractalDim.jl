@doc "Segment/binarize images and compute generalized fractal dimension using Rényi entropy. The package should give approximately the same results as box-counting."
module FractalDim
# Add packages 
using Images, Plots, FractalDimensions, StateSpaceSets, ComplexityMeasures, ImageView

# Export the necessary functions (defined in the source-files).
export analysis
export compute_fractal_dim
export pm_analysis

# Include the source files containing the functions.
include("analysis.jl")
include("compute_fractal_dim.jl")
include("pm_analysis.jl")


end
