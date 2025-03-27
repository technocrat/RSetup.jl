# RSetup

## Julia module for RCall environment
## usage

    setup_r_environment(["name_of_r_package")])

will install a required R package if not already in namespace and make it available to use with [`RCall`](https://github.com/JuliaInterop/RCall.jl).
