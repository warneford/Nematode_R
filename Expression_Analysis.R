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
      Data_Wrm1 <- ImportSCD("Wrm_1_RWT")
      
      # Trim data
      
      Data_Wrm1 <- Trimming(Data_Wrm1, "Wrm_1_RWT")
      
      # Group Embryos by Orientation
      groupdf <- GroupEmb(Data_Wrm1)
      
      # Screen cells for high gene expression &
      listdf <- BlotTime(Data_Wrm1, groupdf)
      
      # Record data type
      Data_B$lineage = "RW10890"
      Data_B$Directory = "RW10890_new"






# Data Visualization

      # Outputs .pdf file showing success of raw blot intensity normalization 
      NormView(Data_Sys1, "JIM 166 Sys-1")
      
      # Subset Averaged blot data for specific expression profiles
      Data_C <- SortBlot2(Data_C, ChangeCVPar = 0.8, ChangeCVDt = 1.2,  MeanLo = 100, MeanHi = Inf, CVLo = 0.0, CVHi = )
      View(Data_C$SortAvCellBlot$Both)
      

      # Plots dual ordinate plot of Averaged blot data (Mean and CV)
      PlotAllCells(LoCell = , HiCell =  , df = Data_C$SortAvCellBlot$Both, sdf = Data_C, sort = "blot",outnames = FALSE)
      names <- PlotAllCells(LoCell = 1, HiCell = , df = Data_C$SortAvCellBlot$Both, sort = "CV",outnames = TRUE)
      names <- as.character(names)
      
      # plots specific cell reporter expression over cell lifetime
      Plotcell("Cppaa", df = Data_C$NormZblot$Both, sdf = Data_C, ancestors = TRUE, outdata = FALSE)
      
      # plots entire lineage of reporter expression over time
      Plotcell("P2", df =  Data_C$NormZblot$Both,sdf = Data_C, ancestors = FALSE, outdata = FALSE)
      
      # Plot lineages of top 20 expressing cells
      pdf(onefile = TRUE, file = "C_RW10890 Pal-1 Cells (20% increase in CV).pdf")
      for (i in 1:length(names))
      {Plotcell(names[i], df = Data_C$NormZblot$Both, sdf = Data_C, ancestors = TRUE)}
      dev.off()
