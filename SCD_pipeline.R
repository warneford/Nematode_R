# Data import and processing

# SCDprocess.R extracts SCD data, trims it, groups it by axis orientation, 
# and normalizes it by Z-plane and raw blot intensity
Data_A <- SCDprocess(lineage = "RW10890", "RW10890")
Data_B <- SCDprocess(lineage = "RW10890", "RW10890_new")
Data_C <- SCDprocess(lineage = "RW10890", Rawdir = "Combined RW10890")
Data_Sys1 <- SCDprocess(lineage = "JIM166", "JIM166")



# To process data manually:

# Import SCD data  
Data_A <- ImportSCD("RW10890")

# Trim data

Data_A <- Trimming(Data_A, "RW10890")

# Group Embryos by Orientation
groupdf <- GroupEmb(Data_A)

# Screen cells for high gene expression &
Data_A <- BlotTime(Data_A, groupdf)

# Record data type
Data_A$lineage = "RW10890"
Data_A$Directory = "RW10890_new"

