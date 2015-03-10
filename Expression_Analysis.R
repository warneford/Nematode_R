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
source('~/Nematode_R/Sortblot2.R')
source('~/Nematode_R/PlotAllCells.R')
source('~/Nematode_R/Plotcell.R')
source('~/Nematode_R/Blotscale.R')
source('~/Nematode_R/BlotApply.R')
source('~/Nematode_R/Zscale.R')
source("~/Nematode_R/trimmingSCD.R")
source("~/Nematode_R/Cell_Timeline.R")
source("~/Nematode_R/GroupEmb.R")
source("~/Nematode_R/NormView.R")
source('~/Nematode_R/SCDprocess.R')

# Data_A - Old RW10890
# Data_B - New RW10890
# Data_C - Combined RW10890

# Specify raw data source directory
Rawdir <- "Combined RW10890"


# SCDprocess.R extracts SCD data, trims it, groups it by axis orientation, 
# and normalizes it by Z-plane and raw blot intensity
Data_C <- SCDprocess(lineage = "RW10890", Rawdir)


# Outputs .pdf file showing success of raw blot intensity normalization 
NormView(Data_C, "Combined RW10890")


# Subset Averaged blot data for specific expression profiles
Data_A <- SortBlot2(Data_A, MeanLo = 0, MeanHi = Inf, CVLo = 0, CVHi = 0.3)


# Plots dual ordinate plot of Averaged blot data (Mean and CV)
PlotAllCells(LoCell = 1, HiCell = , df = Data_B$SortAvCellBlot$Both, sort = "CV",outnames = FALSE)
names <- PlotAllCells(LoCell = 1, HiCell = 35, df = EmbData_A$SortAvCellBlot$Both, sort = "CV",outnames = TRUE)
names <- as.character(names)

# plots specific cell reporter expression over cell lifetime
Plotcell("Eal", df =  Data_B$NormZblot$Both, ancestors = FALSE)

# plots entire lineage of reporter expression over time
Plotcell("Cpppap", df =  EmbData_A$NormZblot$Both, ancestors = TRUE)

# Plot lineages of top 20 expressing cells
pdf(onefile = TRUE, file = "Combined RW10890 Pal-1 Expression_lowCV.pdf" )
for (i in 1:length(names))
{Plotcell(names[i], df = Data_B$NormZblot$Both, ancestors = TRUE)}
dev.off()
  

