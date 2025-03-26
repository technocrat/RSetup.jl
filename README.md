# RSetup.jl

A Julia module for managing R package dependencies and environment setup.

## Installation

```julia
using Pkg
Pkg.add("RSetup")
```

## Usage

```julia
using RSetup

# Initialize R environment and install required packages
RSetup.setup_r_environment()

# Check if packages are installed
RSetup.check_r_packages()
```

## Features

- Automatically installs required R packages
- Provides functions for checking package installation status
- Manages R library paths
- Handles package dependencies
- Includes comprehensive error handling and logging

## Required R Packages

The module manages installation of various R packages including:
- tidyverse and related packages
- Visualization packages (ggplot2, plotly, etc.)
- Geographic data packages (sf, rnaturalearth, etc.)
- Database packages (RPostgreSQL, RSQLite)
- Web scraping packages (httr, rvest)
- And many more...

## License

MIT License 