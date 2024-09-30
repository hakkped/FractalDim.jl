using Images, Plots, FractalDimensions,  ComplexityMeasures, ImageView, ImageBinarization
"""
  compute_fractal_dim(img; [compute_Cs=false], [from_bw=false])

Uses the package FractalDimension.jl for the computation, documentation: https://juliadynamics.github.io/FractalDimensions.jl/stable/

Note that the input image should be cropped to the region of interest.

img: Image to be processed
compute_Cs: Whether or not to compute the fractal dimensions using box-counting
from_bw: WHether or not the input image is already binarized
"""
function compute_fractal_dim(img::Union{Matrix{RGB{N0f8}},Matrix{Float64}}; compute_Cs=false, from_bw=false)
    if !from_bw
        bw_invert_bin = Gray.((Gray.(img) .> 0.6)) # Convert to gray and threshold, see  [here](https://juliaimages.org/latest/examples/color_channels/rgb_grayscale/)
        # bw_invert_bin = 1 .- binarize(img, Otsu()) # Using ImageBinarization, see https://github.com/JuliaImages/ImageBinarization.jl
        else
        bw_invert_bin = img
    end
    components = Images.label_components(bw_invert_bin) # Return matrix of integers
    large_component_ind = argmax(component_lengths(components)[1:end]) # component_lengths returns a offset array
    components[components.!=large_component_ind] .= 0 # Remove anything but the largest connected component
    # # Need to find Cartesian coordinates of every point in image that contains the object.
    cartesian_coordinates = findall(x -> x == large_component_ind, components)
    xy_coordinates = float.(hcat(getindex.(cartesian_coordinates, 1), getindex.(cartesian_coordinates, 2)))
    xy_states = StateSpaceSet(xy_coordinates)
    xy_states_stand= standardize(xy_states)
    box_sizes_stand = estimate_boxsizes(xy_states_stand) # Standardized box size
    box_sizes = estimate_boxsizes(xy_states)
    gendim = generalized_dim(xy_states_stand; q=0) # Generalized (Renyi) entropy
    println("Generalized dimension, mass:", gendim)
# Generalized fractal dimension obtained from Renyi entropy , see https://www.sciencedirect.com/science/article/pii/S0898122113000345
    # Compute the same for front:
    front = pm_front_only(img)
    cartesian_coordinates = findall(x -> x != 0, front)
    xy_coordinates = float.(hcat(getindex.(cartesian_coordinates, 1), getindex.(cartesian_coordinates, 2)))
    xy_states = StateSpaceSet(xy_coordinates)
    xy_states_stand= standardize(xy_states)
    box_sizes_stand = estimate_boxsizes(xy_states_stand) # Standardized box size
    box_sizes = estimate_boxsizes(xy_states)
    gendim_front = generalized_dim(xy_states_stand; q=0) # Generalized (Renyi) entropy
    println("Generalized dimension, front:", gendim_front)

if compute_Cs
        # Compute fractal dimension from scratch, for plotting
        # Separate into function at a later point.
        Cs = correlationsum(xy_states, box_sizes; show_progress=true)
        x=log2.(box_sizes)
        y=log2.(Cs)
        Δ_regions = linear_regions(x, y) # All linear regions.
        Δ_avg = slopefit(x, y, LinearRegression()) # Overall slope fit to all ranges
        Δ_max = slopefit(x, y, LargestLinearRegion()) # Largest linear region.
        println("All linear regions:", Δ_regions)
        println("Average slope fit:", Δ_avg)
        println("Largest linear region:", Δ_max)
    end
    nothing # No return from function
end 

