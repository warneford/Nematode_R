#Script to analyze Reporter fluorescence data

# Clear workspace
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

# Specify raw data directory
Rawdir <- "RW10890"

# Import SCD data
Data <- ImportSCD(Rawdir)

# Generate annotation file for specific SCD data with auxillary information for desired worm strain
RepAuxInfo <- RepAuxfiles("RW10890", Rawdir)

# Trim data
source("trimmingSCD.R")

# Compute Statistics
source("SCD_statistics.R")

# Screen cells for high gene expression
source("Cell_Timeline.R")

# Plots dual ordinate plot of Averaged blot data (Mean and CV)
names <- PlotAllCells(LoCell = 1, HiCell = , df = Data$SortAvCellBlot$Both, sort = "blot",outnames = TRUE)
names <- as.character(names)

# plots specific cell reporter expression over cell lifetime
Plotcell("", df =  Data$EmbOr_NormalizedZ_blot$Both, ancestors = TRUE)

# plots entire lineage of reporter expression over time
Plotcell("Cpppap", df =  Data$EmbOr_NormalizedZ_blot$Both, ancestors = TRUE)

# Plot lineages of top 20 expressing cells
pdf(onefile = TRUE, file = "New RW10890 Pal-1 Expression.pdf")
for (i in 1:length(names))
{Plotcell(names[i], df = Data$EmbOr_NormalizedZ_blot$Both, ancestors = TRUE)}
dev.off()
  rm(i, names, RepAuxInfo)

