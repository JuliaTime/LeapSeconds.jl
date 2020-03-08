using Documenter
using LeapSeconds

makedocs(
    sitename = "LeapSeconds",
    format = Documenter.HTML(),
    modules = [LeapSeconds]
)

deploydocs(
    repo = "github.com/JuliaTime/LeapSeconds.jl.git"
)
