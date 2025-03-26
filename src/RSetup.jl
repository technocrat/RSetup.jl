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
- `R_CHECK_CODE`: R code for checking package installation
- `R_INSTALL_CODE`: R code for installing missing packages

# Functions
- `setup_r_environment()`: Initialize R environment and verify package installation
- `check_r_packages()`: Verify all required R packages are installed
"""
module RSetup

# Constants
const SETUP_COMPLETE = Ref{Bool}(false)
const R_LIBPATH = Ref{String}("")
const R_PACKAGES = [
    "tidyverse",
    "ggplot2",
    "dplyr",
    "tidyr",
    "readr",
    "purrr",
    "tibble",
    "stringr",
    "forcats",
    "lubridate",
    "scales",
    "gridExtra",
    "viridis",
    "RColorBrewer",
    "ggthemes",
    "ggrepel",
    "ggridges",
    "ggmap",
    "sf",
    "rnaturalearth",
    "rnaturalearthdata",
    "rgeos",
    "rgdal",
    "sp",
    "maptools",
    "maps",
    "mapdata",
    "leaflet",
    "htmlwidgets",
    "DT",
    "plotly",
    "htmltools",
    "webshot",
    "png",
    "jpeg",
    "tiff",
    "Cairo",
    "svglite",
    "ragg",
    "showtext",
    "sysfonts",
    "extrafont",
    "extrafontdb",
    "showtextdb",
    "Rttf2pt1",
    "RPostgreSQL",
    "DBI",
    "RSQLite",
    "jsonlite",
    "httr",
    "xml2",
    "rvest",
    "curl",
    "openssl",
    "digest",
    "memoise",
    "cachem",
    "fastmap",
    "later",
    "promises",
    "httpuv",
    "mime",
    "shiny",
    "miniUI",
    "manipulateWidget",
    "htmltools",
    "htmlwidgets",
    "webshot",
    "png",
    "jpeg",
    "tiff",
    "Cairo",
    "svglite",
    "ragg",
    "showtext",
    "sysfonts",
    "extrafont",
    "extrafontdb",
    "showtextdb",
    "Rttf2pt1",
    "RPostgreSQL",
    "DBI",
    "RSQLite",
    "jsonlite",
    "httr",
    "xml2",
    "rvest",
    "curl",
    "openssl",
    "digest",
    "memoise",
    "cachem",
    "fastmap",
    "later",
    "promises",
    "httpuv",
    "mime",
    "shiny",
    "miniUI",
    "manipulateWidget",
    "classInt"
]

const R_CHECK_CODE = """
check_packages <- function(packages) {
    missing_packages <- packages[!sapply(packages, requireNamespace, quietly = TRUE)]
    if (length(missing_packages) > 0) {
        message("Missing packages: ", paste(missing_packages, collapse = ", "))
        return(FALSE)
    }
    return(TRUE)
}
"""

const R_INSTALL_CODE = """
install_packages <- function(packages) {
    for (pkg in packages) {
        if (!requireNamespace(pkg, quietly = TRUE)) {
            message("Installing package: ", pkg)
            install.packages(pkg, repos = "https://cloud.r-project.org/")
            if (!requireNamespace(pkg, quietly = TRUE)) {
                stop("Failed to install package: ", pkg)
            }
        }
    }
    return(TRUE)
}
"""

"""
    setup_r_environment()

Initialize R environment and verify package installation.

Returns:
- `Bool`: true if setup successful, false otherwise
"""
function setup_r_environment()
    try
        # Initialize R environment
        R"library(base)"
        
        # Set R library path
        R_LIBPATH[] = RCall.reval("R.home('library')")
        
        # Define R functions
        RCall.reval(R_CHECK_CODE)
        RCall.reval(R_INSTALL_CODE)
        
        # Check and install packages
        if !check_r_packages()
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
    check_r_packages()

Verify all required R packages are installed.

Returns:
- `Bool`: true if all packages are installed, false otherwise
"""
function check_r_packages()
    try
        # Check if packages are installed
        result = RCall.reval("check_packages($(R_PACKAGES))")
        if !result
            # Try to install missing packages
            RCall.reval("install_packages($(R_PACKAGES))")
            # Check again after installation attempt
            result = RCall.reval("check_packages($(R_PACKAGES))")
        end
        return result
    catch e
        @warn "Failed to check R packages" exception=(e, catch_backtrace())
        return false
    end
end

end # module 