#Script to analyze Reporter fluorescence data

# Clear workspace
rm(list=ls())

# load functions
source('~/Nematode_R/DFtimepts.R')
source('~/Nematode_R/Plotcell.R')
source('~/Nematode_R/Selectcell.R')
source('~/Nematode_R/RepAuxinfo.R')
source('~/Nematode_R/GetParent.R')
source('~/Nematode_R/GetParents.R')
source('~/Nematode_R/ImportSCD.R')
source('~/Nematode_R/Sortblot.R')
source('~/Nematode_R/PlotAllCells.R')
source('~/Nematode_R/Plotcell.R')
source('~/Nematode_R/Blotscale.R')
source('~/Nematode_R/BlotApply.R')
source('~/Nematode_R/Zscale.R')

# Specify raw data source directory
Rawdir <- "Combined RW10890"

# Import SCD data
Data <- ImportSCD(Rawdir)

# Generate annotation file for SCD data with auxillary information for desired worm strain
RepAuxInfo <- RepAuxfiles("RW10890", Rawdir)

# Trim data
source("trimmingSCD.R")

# Compute Statistics
source("SCD_statistics.R")

# Screen cells for high gene expression
source("Cell_Timeline.R")

# Plots dual ordinate plot of Averaged blot data (Mean and CV)
PlotAllCells(LoCell = 1, HiCell = , df = Data$SortAvCellBlot$Both, sort = "CV",outnames = FALSE)
names <- PlotAllCells(LoCell = 1, HiCell = 35, df = Data$SortAvCellBlot$Both, sort = "CV",outnames = TRUE)
names <- as.character(names)

# plots specific cell reporter expression over cell lifetime
Plotcell("Eal", df =  Data$NormZblot$Both, ancestors = TRUE)

# plots entire lineage of reporter expression over time
Plotcell("Cpppap", df =  Data$NormZblot$Both, ancestors = TRUE)

# Plot lineages of top 20 expressing cells
pdf(onefile = TRUE, file = "Combined RW10890 Pal-1 Expression_lowCV.pdf" )
for (i in 1:length(names))
{Plotcell(names[i], df = Data$NormZblot$Both, ancestors = TRUE)}
dev.off()
  rm(i, names, RepAuxInfo)

