#Script to analyze Reporter fluorescence data
# Clear workspace
rm(list=ls())

# load functions
source("~/Nematode_R/Functions.R")
load("Cell_names.RData")
load("Combined Pal-1.RData")


Clin <- AllCells[grep(pattern = "C.+", x = AllCells)]
Clindf <- Selectcell(Cell_names = Clin, blotdf = Data_C$AverageCellblot2$Both)
Early_CLin <- Sortblot(Clindf, TimeMax = 280, outnames = TRUE)
PlotList(Early_CLin ,df = Data_C$NormZblot$Both, sdf = Data_C,name = "C Lineage.pdf")



# Data Visualization

# Outputs .pdf file showing success of raw blot intensity normalization 
NormView(Data_Sys1, "JIM 166 Sys-1")

# Subset Averaged blot data for specific expression profiles
Data_C <- SortBlot2(Data_C, ChangeCVPar = , ChangeCVDt = ,  MeanLo = , MeanHi = Inf, CVLo = 0.0, CVHi = ,MaxTime = Inf)
View(Data_C$SortAvCellBlot$Both)


# Plots dual ordinate plot of Averaged blot data (Mean and CV)
PlotAllCells(LoCell = , HiCell =  , df = Data_C$SortAvCellBlot$Both, sdf = Data_C, sort = "blot",outnames = FALSE)
names <- PlotAllCells(LoCell = 1, HiCell = , df = Data_C$SortAvCellBlot$Both, sort = "CV",outnames = TRUE)
names <- as.character(names)
names
# plots specific cell reporter expression over cell lifetime
Plotcell("Capapp", df = Data_C$NormZblot$Both, sdf = Data_C, ancestors = FALSE, outdata = FALSE)

# plots entire lineage of reporter expression over time
Plotcell("P2", df =  Data_C$NormZblot$Both,sdf = Data_C, ancestors = TRUE, outdata = FALSE)

# Plot lineages of top 20 expressing cells
pdf(onefile = TRUE, file = "test_1.pdf")
for (i in 1:length(names))
{Plotcell(names[i], df = Data_C$NormZblot$Both, sdf = Data_C, ancestors = TRUE)}
dev.off()
