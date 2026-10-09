# RSetup.jl

A Julia module for preparing the [RCall](https://github.com/JuliaInterop/RCall.jl)
environment: it installs required R packages if they are not already available and
loads them for use from Julia.

## Usage

```julia
using RSetup
setup_r_environment(["classInt"])
```

See the [API Reference](api.md) for details.
