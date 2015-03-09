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
source('~/Nematode_R/Cell_Timeline.R')

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

# Plot Mean versus SD of blot data to assess success of normalization method
df <- Data$AverageCellblot$Both
    temp <- lm(df$Mean ~ df$SD)
library(ggplot2)
ggplot(df, aes(x=Mean, y=SD)) +
  geom_point() +
  geom_smooth(method=lm, colour="red") +
  geom_text(aes(x = median(df$Mean, na.rm = TRUE), y = max(df$SD, na.rm = TRUE), label = paste("R^2 is ", format(summary(temp)$adj.r.squared, digits=4)))) +
  ggtitle("Z normalized + blot normalized Mean Pal-1 Blot Values versus Standard Deviation") 
  rm( df, temp)

# Plots dual ordinate plot of Averaged blot data (Mean and CV)
names <- PlotAllCells(LoCell = 136, HiCell = , df = Data$SortAvCellBlot$Both, sort = "blot",outnames = TRUE)
names <- as.character(names)

# plots specific cell reporter expression over cell lifetime
Plotcell("", df =  Data$EmbOr_NormalizedZ_blot$Both, ancestors = TRUE)

# plots entire lineage of reporter expression over time
Plotcell("Cpppap", df =  Data$EmbOr_NormalizedZ_blot$Both, ancestors = TRUE)


# Plot lineages of top 20 expressing cells
pdf(onefile = TRUE, file = "RW10890 Pal-1 Expression.pdf")
for (i in 1:length(names))
{Plotcell(names[i], df = Data$EmbOr_NormalizedZ_blot$Both, ancestors = TRUE)}
dev.off()
  rm(i, names)

