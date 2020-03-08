using Documenter
using LeapSeconds

makedocs(
    sitename = "LeapSeconds",
    format = Documenter.HTML(),
    modules = [LeapSeconds]
)

deploydocs(
    repo = "https://github.com/JuliaTime/LeapSeconds.jl.git"
)
