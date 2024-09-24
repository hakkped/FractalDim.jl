@doc "Segment/binarize images and compute generalized fractal dimension using Rényi entropy. The package should give the same results as box-counting."
module FractalDim
# Add packages. See the documentation for the individual packages for more information.

# Images: Image analysis tools.
# Plots: Framework for plotting
# FractalDimensions: Compute generalized dimension of datasets from e.g. Rényi entropy and correlation sums. 
# StateSpaceSets: Create data type used in FractalDimensions-package from arrays.
# ComplexityMeasures: 
# ImageView: Simple viewing of images.
# using Images, Plots, FractalDimensions, StateSpaceSets, ComplexityMeasures, ImageView

# Export the necessary functions (defined in the source-files).
export analysis
export compute_fractal_dim
export pm_analysis

# Include the source files containing the functions. Order matters.
include("compute_fractal_dim.jl")
include("pm_analysis.jl")
include("analysis.jl")

end
