#Script to analyze Reporter fluorescence data


# load functions
source("~/Nematode_R/Functions.R")

# load vector of cell names
load("Cell_names.RData")

# Generate subsets of various lineages for later indexing
ABlin <- AllCells[grep(pattern = "AB.+", x = AllCells)]
MSlin <- AllCells[grep(pattern = "MS.+", x = AllCells)]
Clin <- AllCells[grep(pattern = "C.+", x = AllCells)]


# Data Visualization

# Outputs .pdf file showing success of raw blot intensity normalization 
NormView(listdf = ,dataname =  "JIM 166 Sys-1")

# Subset Averaged blot data for specific expression profiles
Data_C <- SortBlot2(listdf = Data_C, ChangeCVPar = , ChangeCVDt = ,  MeanLo = 100 , MeanHi = Inf, CVLo = 0.0, CVHi = ,MaxTime = Inf)

# Plots dual ordinate plot of Averaged blot data (Mean and CV)
PlotAllCells(LoCell = 140, HiCell = 160 , df = Data_C$SortAvCellBlot$Both, sdf = Data_C, sort = "blot",outnames = FALSE)



# plots specific cell reporter expression over cell lifetime
Plotcell("ABplpppapa", df = Data_C$NormZblot$Both, sdf = Data_C, ancestors = TRUE, outdata = FALSE)

# plots entire lineage of reporter expression over time
Plotcell("P2", df =  Data_C$NormZblot$Both,sdf = Data_C, ancestors = TRUE, outdata = FALSE)



# Plot lineages of top 20 expressing cells

        # output list of names for plotting multiple lineages
        names <- PlotAllCells(LoCell = 40, HiCell = , df = Data_C$SortAvCellBlot$Both, sort = "CV",outnames = TRUE)
        
        # plot lineages of cells 
        PlotList(list = names,df = Data_C$NormZblot$Both, sdf = Data_C, name = "test_output.pdf", Redundant = FALSE) 
        
