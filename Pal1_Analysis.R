#Script to analyze Pal-1 blotdata


# load functions
source('~/Nematode_R/DFtimepts.R')
source('~/Nematode_R/Plotcell.R')
source('~/Nematode_R/Selectcell.R')

# Import SCD data
source("ImportSCD.R")

# Annotate SCD data with auxillary information
source("AuxinfoRW10890.R")

# Trim data
source("trimmingSCD.R")

# Compute Statistics
source("SCD_statistics.R")

# Screen cells for high gene expression
source("Cell_Timeline.R")


