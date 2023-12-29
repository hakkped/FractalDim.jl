# # # # # # # # # # Most advanced tip
p1=plot((1:1:length(most_adv_flat_02))./((1/2)*122*1) , reverse(most_adv_flat_02)./25, label=L"$\theta=0$, $Q=0.2$", xlabel=L"\tau", ylabel=L"x_{\mathrm{tip}} \ [\mathrm{mm}]")

g=((1:length(most_adv_angle_02[1:216]))./(T_tot_angle_02)) #Times 1 min
f=reverse(most_adv_angle_02[1:216])./25
plot!(g, f, label=L"$\theta=10.1$, $Q=0.2$", ls=:dashdot)

# Plot for 0.04, angle
g=((1:1:length(most_adv_angle_004))./(114)) # Times 10 min
f = reverse(most_adv_angle_004) ./ 25
plot!(g, f, label=L"$\theta=10.1$, $Q=0.04$", ls=:dashdot)

# Plot for 0.04, flat
g = ((1:1:length(most_adv_flat_004[39:end])) ./ (99-38)) # Times 10 min
f = reverse(most_adv_flat_004[1:end-38]) ./ 25
plot!(g, f, label=L"$\theta=0$, $Q=0.04$")

savefig(p1, "most_adv_tip.pdf")

# plot(g[38:end], f[38:end])


# # # # # # # # # # Correlation length \eta (longitudinal direction)
# NOT the same as the front width w! The two are related! See the articles.
# Divide by factor 2 to obtain \eta, see the frontiers article.
p2 = plot((1:1:length(front_width_flat_02)) ./ ((1 / 2) * 122 * 1), (front_width_flat_02) ./ (2*25), label=L"$\theta=0$, $Q=0.2$", xlabel=L"\tau", ylabel=L"\eta \ [\mathrm{mm}]")
mean_front_width_flat_02 = mean(((front_width_flat_02) ./ (2*25))[20:40]) # Approx 34
hspan!([0; 1], [mean_front_width_flat_02; mean_front_width_flat_02], lw=1, lc=:gray, ls=:dot, primary=false)

g = ((1:length(front_width_angle_02[1:216])) ./ (216)) #Times 1 min
f = (front_width_angle_02[1:216]) ./ (2 * 25)
mean_front_width_angle_02 = mean(f[100:end]) # Approx 34
plot!(g, f, label=L"$\theta=10.1$, $Q=0.2$", ls=:dashdot)
hspan!([0; 1], [mean_front_width_angle_02; mean_front_width_angle_02], lw=1, lc=:gray, ls=:dot, primary=false)

# Plot for 0.04, angle
g = ((1:1:length(front_width_angle_004)) ./ (114)) # Times 10 min
f = (front_width_angle_004) ./ (2 * 25)
mean_front_width_angle_004 = mean(f[50:end]) # Approx 100
plot!(g, f, label=L"$\theta=10.1$, $Q=0.04$", ls=:dashdot)
hspan!([0; 1], [mean_front_width_angle_004; mean_front_width_angle_004], lw=1, lc=:grey, ls=:dot, primary=false)

# Plot for 0.04, flat
g = ((1:1:length(front_width_flat_004[39:end])) ./ (99 - 38)) # Times 10 min
f = (front_width_flat_004[1:end-38]) ./ (2 * 25)
mean_front_width_flat_004 = mean(((front_width_flat_004)./(2*25))[25:45]) # Approx 34
hspan!([0; 1], [mean_front_width_flat_004; mean_front_width_flat_004], lw=1, lc=:gray, ls=:dot, primary=false)
plot!(g, f, label=L"$\theta=0$, $Q=0.04$")

savefig(p2, "corr_length.pdf")


# # # # # # # # # # Front width
p4 = plot((1:1:length(σ_y_flat_02)) ./ ((1 / 2) * 122 * 1), (σ_y_flat_02) ./ (25), label=L"$\theta=0$, $Q=0.2$", xlabel=L"\tau", ylabel=L"w \ [\mathrm{mm}]")
mean_front_width_flat_02 = mean(((σ_y_flat_02)./(25))[30:end]) # Approx 34
hspan!([0; 1], [mean_front_width_flat_02; mean_front_width_flat_02], lw=1, lc=:gray, ls=:dot, primary=false)

g = ((1:length(σ_y_angle_02[1:216])) ./ (216)) #Times 1 min
f=(σ_y_angle_02[1:216])./(25)
mean_front_width_angle_02 = mean(f[100:end]) # Approx 34
plot!(g, f, label=L"$\theta=10.1$, $Q=0.2$", ls=:dashdot)
hspan!([0; 1], [mean_front_width_angle_02; mean_front_width_angle_02], lw=1, lc=:gray, ls=:dot, primary=false)

# Plot for 0.04, angle
g = ((1:1:length(σ_y_angle_004)) ./ (114)) # Times 10 min
f = (σ_y_angle_004) ./ (25)
mean_front_width_angle_004 = mean(f[50:end]) # Approx 100
plot!(g, f, label=L"$\theta=10.1$, $Q=0.04$", ls=:dashdot)
hspan!([0; 1], [mean_front_width_angle_004; mean_front_width_angle_004], lw=1, lc=:gray, ls=:dot, primary=false)

# Plot for 0.04, flat
g = ((1:1:length(σ_y_flat_004[39:end])) ./ (99 - 38)) # Times 10 min
f = (σ_y_flat_004[1:end-38]) ./ (25)
mean_front_width_flat_004 = mean(((σ_y_flat_004)./(25))[16:end-38]) # Approx 34
hspan!([0; 1], [mean_front_width_flat_004; mean_front_width_flat_004], lw=1, lc=:gray, ls=:dot, primary=false)
plot!(g, f, label=L"$\theta=0$, $Q=0.04$")

savefig(p4, "front_width.pdf")


# # # # # # # # # # Avg. x-pos
p3 = plot((1:1:length(front_pos_flat_02)) ./ ((1 / 2) * 122 * 1), (front_pos_flat_02) ./ 25, label=L"$\theta=0$, $Q=0.2$", xlabel=L"\tau", ylabel=L"\langle x \rangle \ [\mathrm{mm}]")

g=((1:length(front_pos_angle_02[1:215]))./(215)) #Times 1 min
f=(front_pos_angle_02[1:215])./25
# mean_front_pos_angle_02 = mean(f[100:end]) # Approx 34
plot!(g, f, label=L"$\theta=10.1$, $Q=0.2$", ls=:dashdot)
# hspan!([0; 1], [mean_front_pos_angle_02; mean_front_pos_angle_02], lw=1.5, lc=:black, primary=false)

# Plot for 0.04, angle
g = ((1:1:length(front_pos_angle_004[1:end-2])) ./ (112)) # Times 10 min
f = (front_pos_angle_004[1:end-2]) ./ 25
# mean_front_pos_angle_004 = mean(f[50:end]) # Approx 100
plot!(g, f, label=L"$\theta=10.1$, $Q=0.04$", ls=:dashdot)
# hspan!([0; 1], [mean_front_pos_angle_004; mean_front_pos_angle_004], lw=1.5, lc=:grey, primary=false)

# Plot for 0.04, flat
g = ((1:1:length(front_pos_flat_004[39:end])) ./ (99-38)) # Times 10 min
f = (front_pos_flat_004[1:end-38]) ./ 25

plot!(g, f, label=L"$\theta=0$, $Q=0.04$")

savefig(p3, "front_pos.pdf")

# # # # # # # # # #  Fluctuation number plotting
