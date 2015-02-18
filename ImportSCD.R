# Script to import SCD data 

SCDfiles <- list.files("Raw_data", pattern="^SCD.+\\.csv$")
SCDfiles.path <- paste0("Raw_data/", SCDfiles)

# Construct list of SCD data files
PalData <- list()
PalData[["SCD_Data"]] = list()
PalData[["SCD_Data"]] <- lapply(SCDfiles.path, read.csv)
names(PalData[["SCD_Data"]]) <- gsub(".csv","", SCDfiles)
names(PalData[["SCD_Data"]]) <- gsub("SCD","", names(PalData[["SCD_Data"]]))

