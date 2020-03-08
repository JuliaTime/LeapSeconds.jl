using Documenter
using LeapSeconds

makedocs(
    sitename = "LeapSeconds",
    format = Documenter.HTML(),
    modules = [LeapSeconds]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
