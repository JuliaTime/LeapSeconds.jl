using Documenter
using LeapSeconds
using Documenter.Remotes: GitHub

makedocs(
    sitename = "LeapSeconds",
    format = Documenter.HTML(),
    modules = [LeapSeconds],
    repo = GitHub("JuliaTime/LeapSeconds.jl"),
)

deploydocs(
    repo = "github.com/JuliaTime/LeapSeconds.jl.git"
)
