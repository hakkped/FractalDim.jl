using Images, Plots, FractalDimensions, StateSpaceSets, ComplexityMeasures, ImageView, DataFrames, Statistics, Cairo, ImageBinarization, LaTeXStrings
# export get_all_cropped, pm_analysis, pm_front_only
include("compute_fractal_dim.jl")
include("pm_analysis.jl")
# Drainage experiment
model_width_drainage= 154 #mm
model_length_drainage= 230 #mm
a_pore = 1 # mm, Avg. pore size
h = 2 # mm, internal model height in drainage experiment
γ = 71.7*(1e-3) # N/m, Interface tension, water/air @ 20 degrees C, see here: https://www.sciencedirect.com/science/article/pii/S0920410512002185
g = 9.81 # m/s²
Δ_ρ = 1203 - 1.204  # kg/m³ Density difference between glycerol and air. From first report
ν = 4/3 # Scaling exponent, 2D
μ_w = 43.22*(1e-3) # Pa*s, viscosity of glycerol. From first report.
Q = [0.04, 0.2, 4 , 50] .* (1.66e-8) # List of flow rates, m^3/s
# Front width is expected to scale as Bo as  Bo^{-ν/(1+νf)}
# FF-experiments
model_length_FF = 115 # mm, length
model_width_FF = 66 # mm, width


function analysis(img::Matrix{RGB{N0f8}}; fractal_dim_analysis=false, disp=false)
    bw_invert_bin = Gray.(1 .- (Gray.(img) .> 0.6))
    if fractal_dim_analysis
        # Subplots
        p_sub_1 = plot(img, title="Raw image", titlefontsize=8)
        p_sub_2 = plot(bw_invert_bin, title="Black and white, inverted", titlefontsize=8)
        p_sub = plot(p_sub_1, p_sub_2, layout=@layout([A B]), axis=([], false))
    end
    if disp
        display(p_sub) # Must use display to show plots
    end
end

# Working, for visualization
# seg = unseeded_region_growing(a[1], 0.6)
# seg_img = map(i -> segment_mean(seg, i), labels_map(seg))
# sort(component_lengths(label_components(seg_img))) # to find the right area of the components
# test_2 = area_closing(Gray.(seg_img); min_area=282989, connectivity=2) # remove all smaller clusters, left with front.

# My attempt:
# seg = Gray.(Gray.(a[1]) .> 0.6)

function pm_front_only(img::Matrix{RGB{N0f8}}; bwlevel=0.5)
    # bw_crop = Gray.((Gray.(img) .> bwlevel))
    bw_crop = opening(binarize(img, Otsu()))
    components_for_cluster = Images.label_components(bw_crop)
    large_component_ind = argmax(component_lengths(components_for_cluster)[1:end]) # NOTE: component_lengths returns a offset array, originally 
    bw_crop_largest_component = copy(components_for_cluster)
    # bw_crop_largest_component = components[components.!=large_component_ind]  # Remove anything but the largest connected component

    # Testing
    # min_area_closing = sort(component_lengths(label_components(bw_crop_largest_component)))[end-1]
    # bw_area_closing = area_closing(bw_crop_largest_component; min_area=min_area_closing, connectivity=1) # remove all smaller clusters, left with front.
    # min_area_opening = sort(component_lengths(label_components(bw_area_closing)))[end-2]
    # bw_area_opening = area_opening(bw_area_closing; min_area=min_area_opening, connectivity=1) # remove all smaller clusters, left with front.
    # imshow(bw_area_opening);
    test = similar(bw_crop_largest_component)
    # opening!(bw_crop_largest_component, bw_crop_largest_component, test; r=1)
    diameter_opening!(bw_crop_largest_component, bw_crop_largest_component; min_diameter=60) # Remove connected cylinders. Such a pair typically has a diameter > 60 pixels
    # erode!(bw_crop_largest_component, bw_crop_largest_component; r=2)
    @. bw_crop_largest_component[bw_crop_largest_component != large_component_ind] = 0 # Largest component
    # bw_crop_largest_component
    # bw_crop_largest_component = area_closing()
    bw_crop_largest_component_yee = closing(bw_crop_largest_component; r=3) # Works for all values except for b[3]! Front length diverges for some values, but this is kind of expected.
    B_largest = isboundary(bw_crop_largest_component_yee)
    B_border_front = label_components(B_largest) # Label boundaries, leftmost is 1
    @. B_border_front[B_border_front!=1] = 0 # Keep only the front, everything else set to zero.
    return B_border_front #, bw_area_opening # Return two methods of identifying boundary
end

# # # # # # # # # # Image data  # # # # # # # # # #
pixel_to_mm_50 = 1 / 24 # measured
pixel_to_mm_4 = 1 / 24 # measured
pixel_to_mm_02 = 1 / 24 # measured
pixel_to_mm_004 = 1 / 24 #estimated

pixel_to_mm_50_angle = 1 / 25 # estimated from single picture.
pixel_to_mm_4_angle = 1 / 25
pixel_to_mm_02_angle = 1 / 25
pixel_to_mm_004_angle = 1 / 25

# Fastest to slowest
cc_50 = [456, 3614, 807 , 5641] # 50 ml/min
cc_4 = [510, 3636, 847, 5622] # 4 ml/min
cc_02 = [499, 3671, 951, 5786] # 0.2  ml/min
cc_004 = [444, 3598, 894, 5701] # 0.04  ml/min
window = [cc_004 cc_02 cc_4 cc_50]

cc_50_angle = [429, 3689,312,5272] # 50 ml/min
cc_4_angle = [300,3563,466, 5471] # 4 ml/min
# cc_02_angle = [341, 3609,416, 5433] # 0.2  ml/min
cc_02_angle = [416, 3556, 433, 5391] # 0.2  ml/min
cc_004_angle = [277, 3478, 357, 5317] # 0.04  ml/min
window_angle = [cc_004_angle cc_02_angle cc_4_angle cc_50_angle] #

"""
Get all breakthrough images and save to two arrays, one for the flat and one for the angled model.
"""
function get_all_cropped(group::Int64, window, window_angle)
    img_folder = "../img/final_images/Final_images/"
    group_folder = joinpath(img_folder, readdir(img_folder)[group])
    path_group_images_flat = joinpath(group_folder, sort(readdir(group_folder))[1]) # Flat folder is first
    path_group_images_angle = joinpath(group_folder, sort(readdir(group_folder))[2])
    group_images_flat = sort(readdir(path_group_images_flat)) # List of image names
    group_images_angle = sort(readdir(path_group_images_angle))
    # Load all images
    image_array_angle = Array{Matrix{RGB{N0f8}}}(undef, (1, 4)) # Rows: angle, columns: flow rate
    image_array_flat = Array{Matrix{RGB{N0f8}}}(undef, (1, 4)) # Rows: angle, columns: flow rate
    [image_array_flat[i] = load(joinpath(path_group_images_flat, group_images_flat[i]))[window[:, i][1]:window[:, i][2], window[:, i][3]:window[:, i][4]] for i in 1:4]
    [image_array_angle[i] = load(joinpath(path_group_images_angle, group_images_angle[i]))[window_angle[:, i][1]:window_angle[:, i][2], window_angle[:, i][3]:window_angle[:, i][4]] for i in 1:4]
    return image_array_flat, image_array_angle # Return all images in two arrays.
end
# println(getindex(img["roi"]["zoomregion"]))

"""
Compute all quantities from the eight images. Expect them all in a single array
Report:
    - Fractal dimension of mass
    - Fractal dimension of front
    - Wetting saturation
- ++++
Put everything in dataframe. Convention: start with Bo=0, increasing Ca.
"""
function compute_all(image_array_flat, image_array_angle; img_range::UnitRange{Int64}=1:8)
    image_array = [vec(image_array_flat); vec(image_array_angle)] # Put the two together
    col_names = ["mass_frac_dim", "front_frac_dim", "S_n", "total_area", "solid_area", "pore_area", "solid_fraction", "porosity", "specific_surface_area"]
    df = DataFrame( col_names .=> [zeros(8) for _ in eachindex(col_names)])
    cluster_areas = Vector{Vector{Int64}}(undef, (8))
    bins = Vector{Vector{Int64}}(undef, (8))
    for i in img_range
        largest_comp, clusters, comp, comp_cluster, recreated_reference = pm_analysis(image_array[i]) # Return all
        # Areas/fractions/porosities
        df.total_area[i] = length(comp) # Total area, all pixels
        df.solid_area[i] = length(recreated_reference[recreated_reference.==1]) # Solid areas, computed from recreated reference image
        df.pore_area[i] = df.total_area[i] - df.solid_area[i]
        wetting_is_0 = 1 .- clusters .+ recreated_reference
        wetting_area = length(wetting_is_0[wetting_is_0 .==0])
        df.S_n[i] = (df.pore_area[i] - wetting_area) / df.pore_area[i] # Air saturation. NOTE: Gives same value as if we used comp.
        df.solid_fraction[i] = df.solid_area[i] / df.total_area[i]
        df.porosity[i] = df.pore_area[i] / df.total_area[i]
        df.mass_frac_dim[i] = compute_fractal_dim(image_array[i])
        # boundary = isboundary(comp)
        B_largest = isboundary(largest_comp)
        B_border_front = label_components(B_largest) # Label boundaries, leftmost is 1
        @. B_border_front[B_border_front!=1] = 0 # Keep only the front, everything else set to zero.
        df.front_frac_dim[i] = compute_fractal_dim(float.(B_border_front))
    end
    return df
end



"""
Compute cluster size distribution and bins. Same convention as in previous function: slow to fast, starting with flat experiment.
"""
function compute_cluster_size_dist(image_array_flat, image_array_angle; img_range::UnitRange{Int64}=1:8, threshold=60)
# # # # # # # # # #  Cluster calculations # # # # # # # # # #
    largest_comp, clusters, comp, comp_cluster, recreated_reference = pm_analysis(image_array_flat) # Return all
    largest_comp_angle, clusters_angle, comp_angle, comp_cluster_angle, recreated_reference_angle = pm_analysis(image_array_angle) # Return all
    cluster_areas = component_lengths(comp_cluster)[2:end] # NOTE: Get AREAS of all clusters in image (amount of pixels). Sorted by label.
    deleteat!(cluster_areas, cluster_areas .< threshold) # Remove speckles, small clusters etc.
    b_range = range(minimum(cluster_areas), maximum(cluster_areas), length=100)

    cluster_areas_angle = component_lengths(comp_cluster_angle)[2:end] # Get areas of all clusters in image. Sorted by labelf
    deleteat!(cluster_areas_angle, cluster_areas_angle .< threshold) # Remove speckles, small clusters etc.
    b_range_angle = range(minimum(cluster_areas_angle), maximum(cluster_areas_angle), length=100)
    # # histogram(cluster_areas, bins=b_range, yaxis=(:log10, (1,Inf)), xaxis=(:log10, (1,b_range[end])))
    # histogram(cluster_areas, bins=b_range, yaxis=(:log10, (1, Inf)))
    return cluster_areas, cluster_areas_angle, b_range, b_range_angle
end

"""
Read all images in specified folder for flat and angled experiment
(Do only for experiments 3 and 4)
"""
function series_comp(Q_search, window, window_angle; only_flat_series=true)
    # usb_path_flat = "/run/media/haakonpe/3E85-5931/FYS9420_task3/Angle0/"
    # usb_path_angle = "/run/media/haakonpe/3E85-5931/FYS9420_task3/angle10.10degree/"
    usb_path_flat = "/run/media/haakonpe/3E85-5931/FYS9420_task3/angle10.10degree/" #NOTE: cheating!

    folder_flat = string.(usb_path_flat, filter(x -> startswith(x, string(Q_search)), readdir(usb_path_flat)))[1]
    files_flat = readdir(folder_flat)
    files_flat = filter(!startswith(".") ∘ basename, files_flat) # testing, 65 for first flat, 1:2:122
    # dims = size(load(joinpath(folder_flat, files_flat[1]))[window[:, 1][1]:window[:, 1][2], window[:, 1][3]:window[:, 1][4]])# Get size of array by loading first picture. NOTE the window indices, they have to be set manually
    dims = size(load(joinpath(folder_flat, files_flat[1]))[window_angle[:, 1][1]:window_angle[:, 1][2], window_angle[:, 1][3]:window_angle[:, 1][4]])# Get size of array by loading first picture. NOTE the window indices, they have to be set manually
    # Arrays to be filled
    front_width_values_flat = zeros(length(files_flat))
    #
    avg_front_pos_values_flat = zeros(length(files_flat))
    σ_front_pos_values_flat = zeros(length(files_flat))
    #
    most_advanced_tip_values_flat = zeros(length(files_flat))
    front_mean_wide_values_flat = zeros(length(files_flat))
    front_std_wide_values_flat = zeros(length(files_flat))
    # fill!(most_advanced_tip_values_flat, dims[2])
    #
    img = Matrix{RGB{N0f8}}(undef, dims) # Initialize array to be overwritten
    b_largest = Matrix{Int64}(undef, dims)
    for i in 1:length(files_flat)
        # img .= load( joinpath(folder_flat,files_flat[i]))[window[:, 1][1]:window[:, 1][2], window[:, 1][3]:window[:, 1][4]] #note: window indices are wrong! find way to do this!
        img .= load( joinpath(folder_flat,files_flat[i]))[window_angle[:, 1][1]:window_angle[:, 1][2], window_angle[:, 1][3]:window_angle[:, 1][4]] #note: window indices are wrong! find way to do this!
        b_largest .= pm_front_only(img) # return all
        front_width_values_flat[i] = front_width(b_largest)
        avg_front_pos_values_flat[i], σ_front_pos_values_flat[i] = avg_front_position(b_largest)
        most_advanced_tip_values_flat[i] = most_advanced_tip(b_largest)
        front_mean_wide_values_flat[i], front_std_wide_values_flat[i] = front_width_wide_std(b_largest)
    end
    if !only_flat_series
        usb_path_angle = "/run/media/haakonpe/3E85-5931/FYS9420_task3/angle10.10degree/"
        folder_angle = string.(usb_path_angle, filter(x -> startswith(x, string(Q_search)), readdir(usb_path_angle)))[1]
        files_angle = readdir(folder_angle)
        files_angle = filter(!startswith(".") ∘ basename, files_angle)
        most_advanced_tip_values_angle = zeros(length(files_angle))
        σ_front_pos_values_angle = zeros(length(files_angle))
        avg_front_pos_values_angle = zeros(length(files_angle))
        front_width_values_angle = zeros(length(files_angle))

        for i in 1:length(files_angle)
            img = load(joinpath(folder_angle, files_angle[i]))[window_angle[:, 1][1]:window_angle[:, 1][2], window_angle[:, 1][3]:window_angle[:, 1][4]] #note: window_angle indices are wrong! find way to do this!
            b_largest = pm_front_only(img) # return all
            front_width_values_angle[i] = front_width(b_largest)
            avg_front_pos_values_angle[i], σ_front_pos_values_angle[i] = avg_front_position(b_largest)
            most_advanced_tip_values_angle[i] = most_advanced_tip(b_largest)
        end
    end
    if only_flat_series
        return front_width_values_flat,avg_front_pos_values_flat, σ_front_pos_values_flat, most_advanced_tip_values_flat, front_mean_wide_values_flat, front_std_wide_values_flat
    else
        return front_width_values_flat, avg_front_pos_values_flat, σ_front_pos_values_flat, most_advanced_tip_values_flat, front_width_values_angle, avg_front_pos_values_angle, σ_front_pos_values_angle, most_advanced_tip_values_angle
    end
end



"""
Compute front width from image of front (return in if no kwarg given)
"""
function front_width(front_image::Matrix{Int64}; px_to_mm::Int64 =1)
    M = size(front_image)[2] # length in x-direction
    B_collapse = sum(front_image, dims=1)
    front_width_px = length(B_collapse[B_collapse.!=0]) * px_to_mm # Front width

    return front_width_px
end


function front_width_wide(front_image::Matrix{Int64}; px_to_mm::Int64=1)
    # M = size(front_image)[2] # length in x-direction
    B_collapse = sum(front_image, dims=2)
    front_width_px = length(B_collapse[B_collapse.!=0]) * px_to_mm # Front width
    return front_width_px
end

function front_width_wide_std(front_image::Matrix{Int64}; px_to_mm::Int64=1)
    # M = size(front_image)[2] # length in x-direction
    N = size(front_image)[1]
    M = size(front_image)[2] # length in x-direction
    avg_y_vector = zeros(M)
    for i in 1:M
        ys = findall(y -> y == 1, front_image[:, i])
        if isempty(ys) # Handle case where there is no front.
            avg_y_vector[i] = 0
        else
            avg_y_vector[i] = N-mean(ys)
        end
    end
    avg_front_y = Int(round(mean(avg_y_vector))) * px_to_mm # Average front position
    σ_y = std(avg_y_vector)
    return avg_front_y, σ_y
end

"""
Compute average front position of a image of the front, along with the standard deviation
"""
function avg_front_position(front_image::Matrix{Int64}; px_to_mm::Int64=1)
    N = size(front_image)[1]
    M = size(front_image)[2] # length in x-direction
    avg_x_vector = zeros(N)
    for i in 1:N
        xes = findall(x -> x == 1, front_image[i, :])
        if isempty(xes) # Handle case where there is no front.
            avg_x_vector[i] = 0 
        else
            avg_x_vector[i] = M - mean(xes)
        end
    end
    avg_front_x = Int(round(mean(avg_x_vector))) * px_to_mm # Average front position
    σ = std(avg_x_vector)
    return avg_front_x, σ
end

"""
x-position of most advanced fingertip computed from image of front
"""
function most_advanced_tip(front_image::Matrix{Int64}; px_to_mm::Int64=1)
    M = size(front_image)[2] # length in x-direction
    B_collapse = vec(sum(front_image, dims=1))
    found_indices = findall(x -> x != 0, B_collapse)
    if isempty(found_indices)
        return M * px_to_mm
    else
        first_index = first(found_indices) * px_to_mm
        return first_index
    end

end
# # # # # # # # # # Dimensionless numbers
"""
Compute Bond number from known constants and angle of model. Expects SI.
"""
function Bo(θ::Float64)
    return (Δ_ρ * g *sin(θ*(pi/180)) * (1e-3)^2 / (γ))
end

""" Compute capillary number Ca. Expects SI."""
function Ca(Q::Float64)
    return (μ_w*Q/(γ))
end

# # # # # # # # # #  Plotting functions # # # # # # # # # # 

"""
Plot cluster size distribution.

Keyword allows for adding more plots to the open figure.
"""
function plot_cluster_size_dist(cluster_size_flat::Vector{Int64}, bin_flat::Vector{Int64}, cluster_size_angle::Vector{Int64}, bin_angle::Vector{Int64}, Q, θ; add=false, style=:solid)
    # Plottingexample:  histogram(log10.(e), nbins=30)
    if add
        plot!(reverse(sort(log10.(cluster_size_flat./25))), 1:length(cluster_size_flat), yscale=:log10, label=L"$\theta = 0$, $Q = %$(round(Q; digits=2))$", linestyle=style)
    else
        p1 = plot(reverse(sort(log10.(cluster_size_flat ./ 25))), 1:length(cluster_size_flat), yscale=:log10, label=L"$\theta = 0$, $Q = %$(round(Q; digits=2))$", linestyle=style)
    end
    plot!(reverse(sort(log10.(cluster_size_angle ./ 25))), 1:length(cluster_size_angle), yscale=:log10, label=L"$\theta = %$(round( θ; digits=1))$, $Q = %$(round(Q; digits=2))$", linestyle=style, yticks=([1, 100, 20000]))
    xlabel!(L"\log_{10} (s) \  ") # Size of clusters. s is ratio of cluster size and typical pore size
    ylabel!(L"P(s)") # Number of clusters
    ylims!(1, 10000)
    yticks!([1,100,10000])
    
 # return p1   # display(p1)
end

# # # # # # # # # # Fractional flow-rate caluclations # # # # # # # # # #
# Testing
cc_F025_Q10 = [252 1504 1050 1925 ] # Should be correct for every single one
# window_F025_Q10 = [cc_F025_Q10, cc_F025_Q10, cc_F025_Q10, cc_F025_Q10]
# img_F025Q10 = load("../img/Steady-state-flow/F0.25_Q10/DSC_4160.JPG")[window_F025_Q10[:,1][1]:window_F025_Q10[:,1][2], window_F025_Q10[:,1][3]:window_F025_Q10[:,1][4]]
# img_F025Q10 = load("../img/Steady-state-flow/F0.25_Q10/DSC_4160.JPG")[cc_F025_Q10[1]:cc_F025_Q10[2], cc_F025_Q10[3]:cc_F025_Q10[4]]
# img_F025Q10_ref = load("../img/Steady-state-flow/F0.25_Q10/DSC_4139.JPG")[cc_F025_Q10[1]:cc_F025_Q10[2], cc_F025_Q10[3]:cc_F025_Q10[4]]

# largest_comp_F, clusters_F, comp_F, comp_cluster_F = pm_analysis(img_F025Q10) # Return all

