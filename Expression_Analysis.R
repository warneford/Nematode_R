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
source("trimmingSCD.R")
source("Cell_Timeline.R")

# Specify raw data source directory
Rawdir <- "Combined RW10890"

# Import SCD data
Data_A <- ImportSCD(Rawdir)

# Generate annotation file for SCD data with auxillary information for desired worm strain
RepAuxInfo_A <- RepAuxfiles("RW10890", Rawdir)

# Trim data
Data_A <- Trimming(Data_A)

# Group Embryos by Orientation
EmbData_A <- GroupEmb(Data_A, RepAuxInfo_A)

# Screen cells for high gene expression
EmbData_A <- BlotTime(EmbData_A, EmbData_A)

# Plots dual ordinate plot of Averaged blot data (Mean and CV)
PlotAllCells(LoCell = 1, HiCell = , df = EmbData_A$SortAvCellBlot$Both, sort = "CV",outnames = FALSE)
names <- PlotAllCells(LoCell = 1, HiCell = 35, df = EmbData_A$SortAvCellBlot$Both, sort = "CV",outnames = TRUE)
names <- as.character(names)

# plots specific cell reporter expression over cell lifetime
Plotcell("Eal", df =  EmbData_A$NormZblot$Both, ancestors = TRUE)

# plots entire lineage of reporter expression over time
Plotcell("Cpppap", df =  EmbData_A$NormZblot$Both, ancestors = TRUE)

# Plot lineages of top 20 expressing cells
pdf(onefile = TRUE, file = "Combined RW10890 Pal-1 Expression_lowCV.pdf" )
for (i in 1:length(names))
{Plotcell(names[i], df = EmbData_A$NormZblot$Both, ancestors = TRUE)}
dev.off()
  rm(i, names, RepAuxInfo)

