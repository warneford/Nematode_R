# Compute statistics on blot data

# Compute statistics for (gweight normalized data)

Data$SCDblotsummary$Normalized1_Summary <- cellDFsummary(Data[["Normalized1_blot"]], omit = 2, IDcol = 2, Timecol = 1)

# Compute statistics for (size+gweight normalized data)
Data$SCDblotsummary$Normalized2_Summary <- cellDFsummary(Data[["Normalized2_blot"]], omit = 2, IDcol = 2, Timecol = 1)


# Generate list of embryos grouped by axis
EmbOrientationRL <- c("R", "L") # Enter desired axis groupings, "L" will extract all axis entries ending with "L"
EmbAxisList <- list()
EmbAxisList <- lapply(EmbOrientationRL, function(x) 
                {RepAuxInfo[grep(paste0("^.+",x, "$"), RepAuxInfo$axis), "name"]})
                names(EmbAxisList) <- EmbOrientationRL

# Group SCD data by embryo orientation
EmbAxisData <- lapply(EmbOrientationRL, function(x)  {
      Data$SCD_Data[EmbAxisList[[x]]] })

names(EmbAxisData) <- EmbOrientationRL
