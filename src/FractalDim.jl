@doc "Segment/binarize images and compute generalized fractal dimension using Rényi entropy. The package should give the same results as box-counting."
module FractalDim
# Add packages. See the documentation for the individual packages for more information.

# Export the necessary functions (defined in the source-files with the same names).
export analysis, compute_fractal_dim, pm_analysis, pm_front_only, compute_cluster_size_dist

# Include the source files containing the functions. Order matters.
include("compute_fractal_dim.jl")
include("analysis.jl")
end
