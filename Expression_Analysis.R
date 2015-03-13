#Script to analyze Reporter fluorescence data
# Clear workspace
rm(list=ls())

# load functions
source("~/Nematode_R/Functions.R")
load("Cell_names.RData")
load("Combined Pal-1.RData")

Dlin
Dlin <- AllCells[grep(pattern = "D.+", x = AllCells)]
Dlindf <- Selectcell(Cell_names = Dlin, blotdf = Data_C$AverageCellblot2$Both)
Early_DLin <- Sortblot(Dlindf, TimeMax = 280, outnames = TRUE)
PlotList(Early_DLin ,df = Data_C$NormZblot$Both, sdf = Data_C ,name = "D Lineage_Pal1.pdf",Redundant = FALSE)

foo <- Selectcell(Early_CLin, Data_C$NormZblot$Both, Chronological = FALSE)
View(foo)
Plotcell("P1", df = Data_C$NormZblot$Both, sdf = Data_C, ancestors = FALSE, outdata = FALSE)

# Data Visualization

# Outputs .pdf file showing success of raw blot intensity normalization 
NormView(Data_Sys1, "JIM 166 Sys-1")

# Subset Averaged blot data for specific expression profiles
Data_Sys1 <- SortBlot2(Data_Sys1, ChangeCVPar = , ChangeCVDt = ,  MeanLo = 100 , MeanHi = Inf, CVLo = 0.0, CVHi = ,MaxTime = Inf)
View(Data_C$SortAvCellBlot$Both)


# Plots dual ordinate plot of Averaged blot data (Mean and CV)
PlotAllCells(LoCell = , HiCell =  , df = Data_C$SortAvCellBlot$Both, sdf = Data_C, sort = "blot",outnames = FALSE)
names <- PlotAllCells(LoCell = 1, HiCell = , df = Data_C$SortAvCellBlot$Both, sort = "CV",outnames = TRUE)
names <- as.character(names)
names
# plots specific cell reporter expression over cell lifetime
Plotcell("Cpppa", df = Data_C$NormZblot$Both, sdf = Data_C, ancestors = FALSE, outdata = FALSE)

# plots entire lineage of reporter expression over time
Plotcell("P2", df =  Data_C$NormZblot$Both,sdf = Data_C, ancestors = TRUE, outdata = FALSE)

# Plot lineages of top 20 expressing cells
pdf(onefile = TRUE, file = "test_1.pdf")
for (i in 1:length(names))
{Plotcell(names[i], df = Data_C$NormZblot$Both, sdf = Data_C, ancestors = TRUE)}
dev.off()
