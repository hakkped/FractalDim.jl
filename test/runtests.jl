# include("../src/FractalDim.jl") # SInce FractalDim is local... no solution to this yet, see here https://github.com/julia-vscode/LanguageServer.jl/issues/988
using .FractalDim
using Test #Note that these are for testing only

line = load("../img/line.jpg") # Loads image for testing
compute_fractal_dim(line; compute_Cs=false)
img = pm_analysis(line)
println("EYoh")
# imshow(img)
@testset "FractalDim.jl" begin
    tell = "yo"
    # Write your tests here.
end


