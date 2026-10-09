using Documenter
using MaterialDocs
using RSetup

makedocs(;
    sitename = "RSetup.jl",
    authors = "Richard Careaga <public@careaga.net>",
    modules = [RSetup],
    format = Material3(;
        theme = :ocean_depth,
        dark_mode = :toggle,
        edit_link = "main",
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://technocrat.github.io/RSetup.jl",
    ),
    repo = Remotes.GitHub("technocrat", "RSetup.jl"),
    pages = [
        "Home" => "index.md",
        "API Reference" => "api.md",
    ],
    checkdocs = :none,
)

deploydocs(;
    repo = "github.com/technocrat/RSetup.jl.git",
    devbranch = "main",
)
