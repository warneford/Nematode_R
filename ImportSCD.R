# Script to import SCD data 

SCDfiles <- list.files("Raw_data", pattern="^SCD.+\\.csv$")
SCDfiles.path <- paste0("Raw_data/", SCDfiles)

# Construct list of SCD data files
Data <- list()
Data[["SCD_Data"]] = list()
Data[["SCD_Data"]] <- lapply(SCDfiles.path, read.csv)
names(Data[["SCD_Data"]]) <- gsub(".csv","", SCDfiles)
names(Data[["SCD_Data"]]) <- gsub("SCD","", names(Data[["SCD_Data"]]))
names(Data[["SCD_Data"]]) <- gsub("-1", ".1", names(Data[["SCD_Data"]]))