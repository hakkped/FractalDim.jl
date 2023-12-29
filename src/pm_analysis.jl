"""
Analyze porous medium etc.

Return binarized images of front only, both phases with cylinders removed and both phases with cylinders.
No image manipulation other than diameter closing is performed.
"""
function pm_analysis(img::Matrix{RGB{N0f8}}; cc::Vector{Int64}=[1, size(img)[1], 1, size(img)[2]], threshold::Int64 = 100, bwlevel = 155 / 255, binary_only::Bool =false )
    # crop = img[cc[1]:cc[2], cc[3]:cc[4]] # Use crop coordinates
    # build_histogram(crop)
    bw_crop = Gray.((Gray.(img) .> bwlevel))
    bw_crop_clusters = Gray.(1 .- (Gray.(img) .> bwlevel)) # Must invert to find components correctly. All clusters and contained cylinders are set to the same value!
    if binary_only # Only
        return bw_crop
    end
    components_for_cluster = Images.label_components(bw_crop)
    components = Images.label_components(bw_crop_clusters) # Enumerate components, keep cylinders. NOTE: bw_crop_cluster for enumerating cluster, and bw_crop for identifying the contours of the front
    large_component_ind = argmax(component_lengths(components_for_cluster)[1:end]) # NOTE: component_lengths returns a offset array
    bw_crop_largest_component = copy(components_for_cluster)
    @. bw_crop_largest_component[bw_crop_largest_component!=large_component_ind] = 0 # Keep largest component
    bw_crop_clusters = diameter_closing(Float64.(bw_crop_clusters); min_diameter=threshold) # Keep clusters (do not remove all clusters, discard smaller than 100 pixels), see e.g. https://docs.juliahub.com/ImageMorphology/TCrac/0.3.0/autodocs/#ImageMorphology.diameter_opening
    bw_crop_cluster_open= Gray.(diameter_opening(Float64.(bw_crop); min_diameter=100))
    recreated_reference = bw_crop .- bw_crop_cluster_open # Produces image where cylinders are 1
    components_clusters = Images.label_components(bw_crop_clusters) # Enumerate components
    return bw_crop_largest_component, bw_crop_clusters, components, components_clusters, recreated_reference
end
