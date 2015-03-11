#Script to analyze Reporter fluorescence data
# Clear workspace
rm(list=ls())

# load functions
source("~/Nematode_R/Functions.R")


# Data import and processing

# SCDprocess.R extracts SCD data, trims it, groups it by axis orientation, 
# and normalizes it by Z-plane and raw blot intensity
Data_A <- SCDprocess(lineage = "RW10890", "RW10890")
Data_B <- SCDprocess(lineage = "RW10890", "RW10890_new")
Data_C <- SCDprocess(lineage = "RW10890", "Combined RW10890")
Data_Sys1 <- SCDprocess(lineage = "JIM166", "JIM166")

# To process data manually:

      # Import SCD data  
      Data_B <- ImportSCD("RW10890_new")
      
      # Trim data
      
      Data_B <- Trimming(Data_B, "RW10890", "RW10890_new")
      
      # Group Embryos by Orientation
      groupdf <- GroupEmb(Data_B)
      
      # Screen cells for high gene expression &
      Data_B <- BlotTime(Data_B, groupdf)
      
      # Record data type
      Data_B$lineage = "RW10890"
      Data_B$Directory = "RW10890_new"






# Data Visualization

      # Outputs .pdf file showing success of raw blot intensity normalization 
      NormView(Data_A, "Old RW10890")
      
      # Subset Averaged blot data for specific expression profiles
      Data_B <- SortBlot2(Data_B, MeanLo = 1, MeanHi = Inf, CVLo = 0.0, CVHi = 0.3)
      
      # Plots dual ordinate plot of Averaged blot data (Mean and CV)
      PlotAllCells(LoCell = 1, HiCell = , df = Data_B$SortAvCellBlot$Both, sdf = Data_B, sort = "blot",outnames = FALSE)
      names <- PlotAllCells(LoCell = 1, HiCell = , df = Data_C$SortAvCellBlot$Both, sort = "CV",outnames = TRUE)
      names <- as.character(names)
      
      # plots specific cell reporter expression over cell lifetime
      Plotcell("ABpra", df = Data_A$NormZblot$Both,sdf = Data_A, ancestors = TRUE)
      
      # plots entire lineage of reporter expression over time
      Plotcell("Cppaa", df =  Data_C$NormZblot$Both, ancestors = TRUE)
      
      # Plot lineages of top 20 expressing cells
      pdf(onefile = TRUE, file = "Combined RW10890 Pal-1 Expression_lowCV0.2.pdf")
      for (i in 1:length(names))
      {Plotcell(names[i], df = Data_C$NormZblot$Both, ancestors = TRUE)}
      dev.off()
