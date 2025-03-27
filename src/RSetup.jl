# SPDX-License-Identifier: MIT
module RSetup

using RCall
using Logging

export setup_r_environment, check_r_packages

"""
    RSetup

A module for managing R package dependencies and environment setup.

# Constants
- `SETUP_COMPLETE`: Boolean indicating if R environment setup is complete
- `R_LIBPATH`: Path to R library directory
- `R_PACKAGES`: Array of required R package names

# Functions
- `setup_r_environment()`: Initialize R environment and verify package installation
- `check_r_packages()`: Verify all required R packages are installed
"""

# Constants
const SETUP_COMPLETE = Ref{Bool}(false)
const R_LIBPATH = Ref{String}("")
const R_PACKAGES = [
    "classInt"
]

"""
    setup_r_environment(packages::Vector{String}=R_PACKAGES)

Initialize R environment and verify package installation.

Arguments:
- `packages`: Vector of R package names to install. If not provided, uses the default list in `R_PACKAGES`.

Returns:
- `Bool`: true if setup successful, false otherwise
"""
function setup_r_environment(packages::Vector{String}=R_PACKAGES)
    try
        # Initialize R environment
        rcall(:library, "base")
        
        # Get R version and home directory
        r_version = rcopy(String, R"R.version$version.string")
        r_home = rcopy(String, R"R.home()")
        @info "R Version: $r_version"
        @info "R Home: $r_home"
        
        # Set R library path (use the user's library path)
        lib_paths = rcopy(Vector{String}, rcall(Symbol(".libPaths")))
        @info "R Library Paths: $(join(lib_paths, "\n"))"
        
        # Use the user's library path if available
        user_lib = filter(p -> occursin("Library/R", p), lib_paths)
        if !isempty(user_lib)
            R_LIBPATH[] = user_lib[1]
            @info "Using user library path: $(R_LIBPATH[])"
            
            # Clean up old packages if they exist
            if isdir(R_LIBPATH[])
                @info "Cleaning up old packages..."
                rm(R_LIBPATH[], recursive=true, force=true)
                mkpath(R_LIBPATH[])
            end
        else
            R_LIBPATH[] = lib_paths[1]
            @info "Using system library path: $(R_LIBPATH[])"
        end
        
        # Check and install packages
        if !check_r_packages(packages)
            @warn "Failed to check/install R packages"
            return false
        end
        
        SETUP_COMPLETE[] = true
        return true
    catch e
        @warn "Failed to setup R environment" exception=(e, catch_backtrace())
        return false
    end
end

"""
    check_r_packages(packages::Vector{String}=R_PACKAGES)

Verify all required R packages are installed.

Arguments:
- `packages`: Vector of R package names to check/install. If not provided, uses the default list in `R_PACKAGES`.

Returns:
- `Bool`: true if all packages are installed, false otherwise
"""
function check_r_packages(packages::Vector{String}=R_PACKAGES)
    try
        # First, ensure we have the basic tools
        @info "Installing remotes package..."
        rcall(Symbol("install.packages"), "remotes", repos="https://cloud.r-project.org/")
        
        for pkg in packages
            try
                @info "Checking package: $pkg"
                if !rcopy(Bool, rcall(:requireNamespace, pkg))
                    @info "Installing package: $pkg"
                    rcall(Symbol("install.packages"), pkg, repos="https://cloud.r-project.org/")
                    if !rcopy(Bool, rcall(:requireNamespace, pkg))
                        @warn "Failed to install package: $pkg"
                        return false
                    end
                    @info "Successfully installed and loaded package: $pkg"
                else
                    @info "Package already installed: $pkg"
                end
            catch e
                @warn "Error with package $pkg" exception=(e, catch_backtrace())
                return false
            end
        end
        return true
    catch e
        @warn "Failed to check R packages" exception=(e, catch_backtrace())
        return false
    end
end

end # module 