using Images, ImageBinarization, Distributions

# function analyze_Steady_Image()
cc_F025_Q10 = [252, 1504, 1050, 1925 ] # Only hold when Q=10
cc = [279, 1532, 890, 1773] # Same for all other images


# Testing 

# # # # # # # # # #  Q = 0.4
# F = 0.25, Q=0.4
# define cc
img_F025Q04_ref = load("../img/Steady-state-flow/F0.25_Q0.4/DSC_4348.JPG")[cc[1]:cc[2], cc[3]:cc[4]]
img_F025Q04 = load("../img/Steady-state-flow/F0.25_Q0.4/DSC_4434.JPG")[cc[1]:cc[2], cc[3]:cc[4]]


# Find threshold from entropy
edges, counts = Images.build_histogram(img_F025Q04, 256)
edges_ref, counts_ref = Images.build_histogram(img_F025Q04_ref, 256)
f_F025Q04 = find_threshold(counts[1:end], edges, Entropy())
f_F025Q04_ref = find_threshold(counts_ref[1:end], edges_ref, Entropy())
img_F025Q04_gray = @. Gray(Gray.(img_F025Q04) > f_F025Q04)
img_F025Q04_gray_ref = @. Gray(Gray.(img_F025Q04_ref) > f_F025Q04_ref)

diff_image_F025Q04 = img_F025Q04_gray .- img_F025Q04_gray_ref
opened_F025Q04 = opening(Gray.(diff_image_F025Q04))
S_n_F025Q04 = length(opened_F025Q04[opened_F025Q04.==1]) / length(opened_F025Q04)

# F = 1, Q=0.4
# define cc
img_F1Q04_ref = load("../img/Steady-state-flow/F1,Q0_4/DSC_4188.JPG")[cc[1]:cc[2], cc[3]:cc[4]]
img_F1Q04 = load("../img/Steady-state-flow/F1,Q0_4/DSC_4326.JPG")[cc[1]:cc[2], cc[3]:cc[4]]
#
# Find threshold from entropy
edges, counts = Images.build_histogram(img_F1Q04, 256)
edges_ref, counts_ref = Images.build_histogram(img_F1Q04_ref, 256)
f_F1Q04 = find_threshold(counts[1:end], edges, Entropy())
f_F1Q04_ref = find_threshold(counts_ref[1:end], edges_ref, Entropy())
img_F1Q04_gray = @. Gray(Gray.(img_F1Q04) > f_F1Q04)
img_F1Q04_gray_ref = @. Gray(Gray.(img_F1Q04_ref) > f_F1Q04_ref)

diff_image_F1Q04 = img_F1Q04_gray .- img_F1Q04_gray_ref
opened_F1Q04 = opening(Gray.(diff_image_F1Q04))
S_n_F1Q04 = length(opened_F1Q04[opened_F1Q04.==1]) / length(opened_F1Q04)

# F = 4, Q=0.4
# define cc
img_F4Q04_ref = load("../img/Steady-state-flow/F4_Q0.4/DSC_4436.JPG")[cc[1]:cc[2], cc[3]:cc[4]]
img_F4Q04 = load("../img/Steady-state-flow/F4_Q0.4/DSC_4484.JPG")[cc[1]:cc[2], cc[3]:cc[4]]
#
# Find threshold from entropy
edges, counts = Images.build_histogram(img_F4Q04, 256)
edges_ref, counts_ref = Images.build_histogram(img_F4Q04_ref, 256)
f_F4Q04 = find_threshold(counts[1:end], edges, Entropy())
f_F4Q04_ref = find_threshold(counts_ref[1:end], edges_ref, Entropy())
img_F4Q04_gray = @. Gray(Gray.(img_F4Q04) > f_F4Q04)
img_F4Q04_gray_ref = @. Gray(Gray.(img_F4Q04_ref) > f_F4Q04_ref)

diff_image_F4Q04 = img_F4Q04_gray .- img_F4Q04_gray_ref
opened_F4Q04 = opening(Gray.(diff_image_F4Q04))
S_n_F4Q04 = length(opened_F4Q04[opened_F4Q04.==1]) / length(opened_F4Q04)

# # # # # # # # # #  Q = 2
# F = 0.25, Q=2
# define cc
img_F025Q2_ref = load("../img/Steady-state-flow/F0.25_Q2/DSC_4328.JPG")[cc[1]:cc[2], cc[3]:cc[4]]
img_F025Q2 = load("../img/Steady-state-flow/F0.25_Q2/DSC_4346.JPG")[cc[1]:cc[2], cc[3]:cc[4]]
#

# Find threshold from entropy
edges, counts = Images.build_histogram(img_F025Q2, 256)
edges_ref, counts_ref = Images.build_histogram(img_F025Q2_ref, 256)
f_F025Q2 = find_threshold(counts[1:end], edges, Entropy())
f_F025Q2_ref = find_threshold(counts_ref[1:end], edges_ref, Entropy())
img_F025Q2_gray = @. Gray(Gray.(img_F025Q2) > f_F025Q2)
img_F025Q2_gray_ref = @. Gray(Gray.(img_F025Q2_ref) > f_F025Q2_ref)

diff_image_F025Q2 = img_F025Q2_gray .- img_F025Q2_gray_ref
opened_F025Q2 = opening(Gray.(diff_image_F025Q2))
S_n_F025Q2 = length(opened_F025Q2[opened_F025Q2.==1]) / length(opened_F025Q2)


# F = 1, Q=2
# define cc
img_F1Q2_ref = load("../img/Steady-state-flow/F1_Q2_NEW/DSC_4541.JPG")[cc[1]:cc[2], cc[3]:cc[4]]
img_F1Q2 = load("../img/Steady-state-flow/F1_Q2_NEW/DSC_4563.JPG")[cc[1]:cc[2], cc[3]:cc[4]]
#
# Find threshold from entropy
edges, counts = Images.build_histogram(img_F1Q2, 256)
edges_ref, counts_ref = Images.build_histogram(img_F1Q2_ref, 256)
f_F1Q2 = find_threshold(counts[1:end], edges, Entropy())
f_F1Q2_ref = find_threshold(counts_ref[1:end], edges_ref, Entropy())
img_F1Q2_gray = @. Gray(Gray.(img_F1Q2) > f_F1Q2)
img_F1Q2_gray_ref = @. Gray(Gray.(img_F1Q2_ref) > f_F1Q2_ref)

diff_image_F1Q2 = img_F1Q2_gray .- img_F1Q2_gray_ref
opened_F1Q2 = opening(Gray.(diff_image_F1Q2)) # Remove white speckles etc. by opening
S_n_F1Q2 = length(opened_F1Q2[opened_F1Q2.==1]) / length(opened_F1Q2)


# F = 4, Q=2

# define cc
img_F4Q2_ref = load("../img/Steady-state-flow/F4_Q2_NEW/DSC_4495.JPG")[cc[1]:cc[2], cc[3]:cc[4]]
img_F4Q2 = load("../img/Steady-state-flow/F4_Q2_NEW/DSC_4539.JPG")[cc[1]:cc[2], cc[3]:cc[4]]
#
# Find threshold from entropy
edges, counts = Images.build_histogram(img_F4Q2, 256)
edges_ref, counts_ref = Images.build_histogram(img_F4Q2_ref, 256)
f_F4Q2 = find_threshold(counts[1:end], edges, Entropy())
f_F4Q2_ref = find_threshold(counts_ref[1:end], edges_ref, Entropy())
img_F4Q2_gray = @. Gray(Gray.(img_F4Q2) > f_F4Q2)
img_F4Q2_gray_ref = @. Gray(Gray.(img_F4Q2_ref) > f_F4Q2_ref)

diff_image_F4Q2 = img_F4Q2_gray .- img_F4Q2_gray_ref
opened_F4Q2 = opening(Gray.(diff_image_F4Q2))
S_n_F4Q2 = length(opened_F4Q2[opened_F4Q2.==1]) / length(opened_F4Q2)


# # # # # # # # # #  Q = 10

# F = 0.25, Q=10
img_F025Q10_ref = load("../img/Steady-state-flow/F0.25_Q10/DSC_4139.JPG")[cc_F025_Q10[1]:cc_F025_Q10[2], cc_F025_Q10[3]:cc_F025_Q10[4]]
img_F025Q10 = load("../img/Steady-state-flow/F0.25_Q10/DSC_4160.JPG")[cc_F025_Q10[1]:cc_F025_Q10[2], cc_F025_Q10[3]:cc_F025_Q10[4]]

edges, counts = Images.build_histogram(img_F025Q10, 256)
edges_ref, counts_ref = Images.build_histogram(img_F025Q10_ref, 256)
f_F025Q10 = find_threshold(counts[1:end], edges, Entropy())
f_F025Q10_ref = find_threshold(counts_ref[1:end], edges_ref, Entropy())
img_F025Q10_gray = @. Gray(Gray.(img_F025Q10) > f_F025Q10)
img_F025Q10_gray_ref = @. Gray(Gray.(img_F025Q10_ref) > f_F025Q10_ref)

diff_image_F025Q10 = img_F025Q10_gray .- img_F025Q10_gray_ref
opened_F025Q10 = opening(Gray.(diff_image_F025Q10))
S_n_F025Q10 = length(opened_F025Q10[opened_F025Q10.==1]) / length(opened_F025Q10)

# F = 1, Q=10
img_F1Q10_ref = load("../img/Steady-state-flow/F1_Q10/DSC_4085.JPG")[cc_F025_Q10[1]:cc_F025_Q10[2], cc_F025_Q10[3]:cc_F025_Q10[4]]
img_F1Q10 = load("../img/Steady-state-flow/F1_Q10/DSC_4103.JPG")[cc_F025_Q10[1]:cc_F025_Q10[2], cc_F025_Q10[3]:cc_F025_Q10[4]]

edges, counts = Images.build_histogram(img_F1Q10, 256)
edges_ref, counts_ref = Images.build_histogram(img_F1Q10_ref, 256)
f_F1Q10 = find_threshold(counts[1:end], edges, Entropy())
f_F1Q10_ref = find_threshold(counts_ref[1:end], edges_ref, Entropy())
img_F1Q10_gray = @. Gray(Gray.(img_F1Q10) > f_F1Q10)
img_F1Q10_gray_ref = @. Gray(Gray.(img_F1Q10_ref) > f_F1Q10_ref)

diff_image_F1Q10 = img_F1Q10_gray .- img_F1Q10_gray_ref
opened_F1Q10 = opening(Gray.(diff_image_F1Q10))
S_n_F1Q10 = length(opened_F1Q10[opened_F1Q10.==1]) / length(opened_F1Q10)

# F = 4, Q=10
img_F4Q10_ref = load("../img/Steady-state-flow/F4_Q10/DSC_4106.JPG")[cc_F025_Q10[1]:cc_F025_Q10[2], cc_F025_Q10[3]:cc_F025_Q10[4]]
img_F4Q10 = load("../img/Steady-state-flow/F4_Q10/DSC_4136.JPG")[cc_F025_Q10[1]:cc_F025_Q10[2], cc_F025_Q10[3]:cc_F025_Q10[4]]

imshow(img_F4Q10);
imshow(img_F4Q10_ref);

edges, counts = Images.build_histogram(img_F4Q10, 256)
edges_ref, counts_ref = Images.build_histogram(img_F4Q10_ref, 256)
f_F4Q10 = find_threshold(counts[1:end], edges, Entropy())
f_F4Q10_ref = find_threshold(counts_ref[1:end], edges_ref, Entropy())
img_F4Q10_gray = @. Gray(Gray.(img_F4Q10) > f_F4Q10)
img_F4Q10_gray_ref = @. Gray(Gray.(img_F4Q10_ref) > f_F4Q10_ref)


diff_image_F4Q10 = img_F4Q10_gray .- img_F4Q10_gray_ref
# imshow(diff_image_F4Q10);
opened_F4Q10 = opening(Gray.(diff_image_F4Q10))
S_n_F4Q10 = length(opened_F4Q10[opened_F4Q10.==1]) / length(opened_F4Q10)

# # # # # # # # # #  Compute cluster size distribution means
comp_F025Q04 = label_components(opened_F025Q04)[1:end]
comp_F1Q04 = label_components(opened_F1Q04)[1:end]
comp_F4Q04 = label_components(opened_F4Q04)[1:end]

comp_F025Q2 = label_components(opened_F025Q2)[1:end]
comp_F1Q2 = label_components(opened_F1Q2)[1:end]
comp_F4Q2 = label_components(opened_F4Q2)[1:end]

comp_F025Q10 = label_components(opened_F025Q10)[1:end]
comp_F1Q10 = label_components(opened_F1Q10)[1:end]
comp_F4Q10 = label_components(opened_F4Q10)[1:end]


# Compute components sizes (in pixels)
mean_component_lengths_F025Q04 = mean(component_lengths(comp_F025Q04)[1:end])
mean_component_lengths_F1Q04 = mean(component_lengths(comp_F1Q04)[1:end])
mean_component_lengths_F4Q04 = mean(component_lengths(comp_F4Q04)[1:end])

mean_component_lengths_F025Q2 = mean(component_lengths(comp_F025Q2)[1:end])
mean_component_lengths_F1Q2 = mean(component_lengths(comp_F1Q2)[1:end])
mean_component_lengths_F4Q2 = mean(component_lengths(comp_F4Q2)[1:end])

mean_component_lengths_F025Q10 = mean(component_lengths(comp_F025Q10)[1:end])
mean_component_lengths_F1Q10 = mean(component_lengths(comp_F1Q10)[1:end])
mean_component_lengths_F4Q10 = mean(component_lengths(comp_F4Q10)[1:end])

# Compute standard deviation of the distribution
std_component_lengths_F025Q04 = std(component_lengths(comp_F025Q04)[1:end])
std_component_lengths_F1Q04 = std(component_lengths(comp_F1Q04)[1:end])
std_component_lengths_F4Q04 = std(component_lengths(comp_F4Q04)[1:end])

std_component_lengths_F025Q2 = std(component_lengths(comp_F025Q2)[1:end])
std_component_lengths_F1Q2 = std(component_lengths(comp_F1Q2)[1:end])
std_component_lengths_F4Q2 = std(component_lengths(comp_F4Q2)[1:end])

std_component_lengths_F025Q10 = std(component_lengths(comp_F025Q10)[1:end])
std_component_lengths_F1Q10 = std(component_lengths(comp_F1Q10)[1:end])
std_component_lengths_F4Q10 = std(component_lengths(comp_F4Q10)[1:end])
