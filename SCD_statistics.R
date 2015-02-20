# Compute statistics on Pal-1 blot data
PalData[["SCDblotsummary"]] <- PalData[["SCD_Data"]][[1]][,c(1,2)]

# Compute statistics for (gweight normalized data)

PalData$SCDblotsummary$Normalized1_Summary <- cellDFsummary(PalData[["Normalized1_blot"]], omit = 2, IDcol = 2, Timecol = 1)

# Compute statistics for (size+gweight normalized data)
PalData$SCDblotsummary$Normalized2_Summary <- cellDFsummary(PalData[["Normalized2_blot"]], omit = 2, IDcol = 2, Timecol = 1)


# Generate list of embryos grouped by axis
EmbOrientationRL <- c("R", "L") # Enter desired axis groupings, "L" will extract all axis entries ending with "L"
EmbAxisList <- list()
EmbAxisList <- lapply(EmbOrientationRL, function(x) 
                {AuxRW10890[grep(paste0("^.+",x, "$"), AuxRW10890$axis), "name"]})
                names(EmbAxisList) <- EmbOrientationRL

# Group SCD data by embryo orientation
EmbAxisData <- lapply(EmbOrientationRL, function(x)  {
      PalData$SCD_Data[EmbAxisList[[x]]] })
      names(EmbAxisData) <- EmbOrientationRL

# Compute linear regression
lm.reg <- lm(PalData[["SCDblot_cutoff"]]$Std_dev ~ PalData[["SCDblot_cutoff"]]$Mean)

lm.norm1 <- lm(PalData[["SCDblot_cutoff"]]$Normalized1_Std_dev ~ PalData[["SCDblot_cutoff"]]$Normalized1_Mean)
lm.norm2 <- lm(PalData[["SCDblot_cutoff"]]$Normalized2_Std_dev ~ PalData[["SCDblot_cutoff"]]$Normalized2_Mean)
lm.normZ <- lm(PalData[["SCDblot_cutoff"]]$NormalizedZ_Std_dev ~ PalData[["SCDblot_cutoff"]]$NormalizedZ_Mean)
