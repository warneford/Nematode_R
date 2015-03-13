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
names(Early_CLin)
