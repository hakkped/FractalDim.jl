using .FractalDim: compute_fractal_dim

"""
  analysis(img; [fractal_dim_analysis=false], [disp=false])

Perform basic analysis of input image.

Returns plot object.
TODO: extend function with relevant plots/images from the other functions in this package.

img: Image to be processed
fractal_dim_analysis: Perform analysis
disp: Whether or not to display the results.
"""
function analysis(img::Matrix{RGB{N0f8}}; fractal_dim_analysis=false, disp=false)
    p_sub = plot() # Create plot object
    bw_invert_bin = Gray.(1 .- (Gray.(img) .> 0.6)) # Greyscale image
    if fractal_dim_analysis # If analysis to be done
        # Subplots
        p_sub_1 = plot(img, title="Raw image", titlefontsize=8)
        p_sub_2 = plot(bw_invert_bin, title="Black and white, inverted", titlefontsize=8)
        p_sub = plot(p_sub_1, p_sub_2, layout=@layout([A B]), axis=([], false))
    end
    if disp
        display(p_sub) # Display the images
    end
    return p_sub # Return plot object
end

"""
  pm_analysis(img; [ cc=[1, size(img)[1], 1, size(img)[2]] ], [ threshold = 100 ], [bwlevel = 155 / 255], [binary_only =false] )

Analyze porous medium. Return binarized images of front, both phases with cylinders removed and both phases with cylinders.
The function simply identifies the front with the largest connected component.
No image manipulation other than diameter closing is performed.

img: Image to be processed
cc: Part of image to be processed in pixels, height then width.
threshold: Minimum diameter of clusters
bwlevel: BW-binarization threshold
binary_only: Whether or not to only return the binarized

"""
function pm_analysis(img::Matrix{RGB{N0f8}}; cc::Vector{Int64}=[1, size(img)[1], 1, size(img)[2]], threshold::Int64 = 100, bwlevel = 155 / 255, binary_only::Bool =false )
    img = img[cc[1]:cc[2], cc[3]:cc[4]] # Use crop coordinates
    bw_crop = Gray.((Gray.(img) .> bwlevel))
    bw_crop_clusters = Gray.(1 .- (Gray.(img) .> bwlevel)) # Must invert to find components correctly. All clusters and contained cylinders are set to the same value!
    if binary_only 
        return bw_crop # Return cropped BW-image only
    end
    components_for_cluster = Images.label_components(bw_crop)
    components = Images.label_components(bw_crop_clusters) # Enumerate components, keep cylinders. NOTE: bw_crop_cluster for enumerating cluster, and bw_crop for identifying the contours of the front
    large_component_ind = argmax(component_lengths(components_for_cluster)[1:end]) # NOTE: component_lengths returns an offset array
    bw_crop_largest_component = copy(components_for_cluster)
    @. bw_crop_largest_component[bw_crop_largest_component!=large_component_ind] = 0 # Keep largest component
    bw_crop_clusters = diameter_closing(Float64.(bw_crop_clusters); min_diameter=threshold) # Keep clusters (discard those smaller than 100 pixels), see e.g. https://docs.juliahub.com/ImageMorphology/TCrac/0.3.0/autodocs/#ImageMorphology.diameter_opening
    bw_crop_cluster_open= Gray.(diameter_opening(Float64.(bw_crop); min_diameter=100))
    recreated_reference = bw_crop .- bw_crop_cluster_open # Produces image where cylinders have value 1
    components_clusters = Images.label_components(bw_crop_clusters) # Enumerate components
    return bw_crop_largest_component, bw_crop_clusters, components, components_clusters, recreated_reference
end

"""
   pm_front_only(img; [bwlevel=0.5])

Identify front as the boundary of the largest connected component. This definition is a bit naive, and requires careful usage (manual verification is recommended).

Arguments:
img: Image to be processed.
bwlevel: threshold level
"""
function pm_front_only(img::Matrix{RGB{N0f8}}; bwlevel=0.5)
    # bw_crop = Gray.((Gray.(img) .> bwlevel)) # Greyscale with manual threshold
    bw_crop = opening(binarize(img, Otsu())) # Use Otsu binarization for  thresholding
    components_for_cluster = Images.label_components(bw_crop)
    large_component_ind = argmax(component_lengths(components_for_cluster)[1:end]) # NOTE: component_lengths returns a offset array, originally 
    bw_crop_largest_component = copy(components_for_cluster)
    test = similar(bw_crop_largest_component)
    diameter_opening!(bw_crop_largest_component, bw_crop_largest_component; min_diameter=60) # Remove connected cylinders. Such a pair typically has a diameter > 60 pixels
    @. bw_crop_largest_component[bw_crop_largest_component != large_component_ind] = 0 # Largest component
    bw_crop_largest_component_yee = closing(bw_crop_largest_component) # Works for all values except for b[3]! Front length diverges for some values, but this is kind of expected.
    B_largest = isboundary(bw_crop_largest_component_yee)
    B_border_front = label_components(B_largest) # Label boundaries, leftmost is 1
    @. B_border_front[B_border_front!=1] = 0 # Keep only the front, everything else set to zero.
    return B_border_front #, bw_area_opening # Return two methods of identifying boundary
end

"""
  compute_cluster_size_dist(comp_cluster; [threshold=60])

Compute cluster size distribution and bins.

comp_cluster: image with labeled components. E.g. the output "component_clusters" from the function "pm_analysis".
threshold: minimum cluster size
"""
function compute_cluster_size_dist(comp_cluster::Matrix{Int64}; threshold=60)
    cluster_areas = component_lengths(comp_cluster)[2:end] # Get AREAS of all clusters in image (number of pixels!). Sorted by label.
    deleteat!(cluster_areas, cluster_areas .< threshold) # Remove speckles, small clusters etc.
    b_range = range(minimum(cluster_areas), maximum(cluster_areas), length=100) # Bins
    # histogram(cluster_areas, bins=b_range, yaxis=(:log10, (1, Inf)))
    return cluster_areas, b_range
end


