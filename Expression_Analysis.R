#Script to analyze Reporter fluorescence data

# load functions
source('~/Nematode_R/DFtimepts.R')
source('~/Nematode_R/Plotcell.R')
source('~/Nematode_R/Selectcell.R')
source('~/Nematode_R/RepAuxinfo.R')

# Import SCD data
source("ImportSCD.R")

# Generate annotation file for specific SCD data with auxillary information for desired worm strain
RepAuxInfo <- RepAuxfiles("RW10890")

# Trim data
source("trimmingSCD.R")

# Compute Statistics
source("SCD_statistics.R")

# Screen cells for high gene expression
source("Cell_Timeline.R")

# Plots dual ordinate plot of Averaged blot data (Mean and CV)
PlotAllCells(LoCell = 1, HiCell = , df = Data$SortAvCellBlot$Both, sort = "time")
# Sort chronologically, sort by CV, sort by lineage

GetParents("ABaplpa")

# plots specific cell reporter expression over cell lifetime
Plotcell("D", df =  Data$EmbOr_NormalizedZ_blot$Both)
# Modify plotcell to show ancestor expression of Pal-1
x <- "ABplpaa"
substr(x,nchar(x),nchar(x))





