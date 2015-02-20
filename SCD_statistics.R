# Compute statistics on Pal-1 blot data
PalData[["SCDblotsummary"]] <- PalData[["SCD_Data"]][[1]][,c(1,2)]

# Compute statistics for unnormalized data
PalData[["SCDblotsummary"]][,"Mean"] <- apply(PalData[["SCD_blot"]][-c(1,2)], 1, function(x) {mean(x, na.rm=TRUE)})
PalData[["SCDblotsummary"]][,"Variance"] <- apply(PalData[["SCD_blot"]][-c(1,2)], 1, function(x) {var(x, na.rm=TRUE)})
PalData[["SCDblotsummary"]][,"Std_dev"] <- apply(PalData[["SCD_blot"]][-c(1,2)], 1, function(x) {sd(x, na.rm=TRUE)})
PalData[["SCDblotsummary"]][,"Mean_size"] <- apply(as.data.frame(lapply(PalData[["SCD_Data"]], function(x) {x$size})), 1, function(x) {mean(x, na.rm=TRUE)})

# Compute statistics for (gweight normalized data)
PalData[["SCDblotsummary"]][,"Normalized1_Mean"] <- apply(PalData[["Normalized1_blot"]], 1, function(x) {mean(x, na.rm=TRUE)})
PalData[["SCDblotsummary"]][,"Normalized1_Variance"] <- apply(PalData[["Normalized1_blot"]], 1, function(x) {var(x, na.rm=TRUE)})
PalData[["SCDblotsummary"]][,"Normalized1_Std_dev"] <- apply(PalData[["Normalized1_blot"]], 1, function(x) {sd(x, na.rm=TRUE)})

# Compute statistics for (size+gweight normalized data)
PalData[["SCDblotsummary"]][,"Normalized2_Mean"] <- apply(PalData[["Normalized2_blot"]], 1, function(x) {mean(x, na.rm=TRUE)})
PalData[["SCDblotsummary"]][,"Normalized2_Variance"] <- apply(PalData[["Normalized2_blot"]], 1, function(x) {var(x, na.rm=TRUE)})
PalData[["SCDblotsummary"]][,"Normalized2_Std_dev"] <- apply(PalData[["Normalized2_blot"]], 1, function(x) {sd(x, na.rm=TRUE)})

# Compute statistics for Z normalized data
PalData[["SCDblotsummary"]][,"NormalizedZ_Mean"] <- apply(PalData[["NormalizedZ_blot"]][-c(1,2)], 1, function(x) {mean(x, na.rm=TRUE)})
PalData[["SCDblotsummary"]][,"NormalizedZ_Variance"] <- apply(PalData[["NormalizedZ_blot"]][-c(1,2)], 1, function(x) {var(x, na.rm=TRUE)})
PalData[["SCDblotsummary"]][,"NormalizedZ_Std_dev"] <- apply(PalData[["NormalizedZ_blot"]][-c(1,2)], 1, function(x) {sd(x, na.rm=TRUE)})

# Generate list of embryos grouped by axis
EmbOrientationRL <- c("R", "L") # Enter desired axis groupings, "L" will extract all axis entries ending with "L"
EmbAxisList <- list()
EmbAxisList <- lapply(EmbOrientationRL, function(x) 
  {AuxRW10890[grep(paste0("^.+",x, "$"), AuxRW10890$axis), "name"]})
names(EmbAxisList) <- EmbOrientationRL


# Set lower cutoff for mean blot value
PalData[["SCDblot_cutoff"]] <- subset(PalData[["SCDblotsummary"]], (NormalizedZ_Mean > 100))

# Compute linear regression
lm.reg <- lm(PalData[["SCDblot_cutoff"]]$Std_dev ~ PalData[["SCDblot_cutoff"]]$Mean)

lm.norm1 <- lm(PalData[["SCDblot_cutoff"]]$Normalized1_Std_dev ~ PalData[["SCDblot_cutoff"]]$Normalized1_Mean)
lm.norm2 <- lm(PalData[["SCDblot_cutoff"]]$Normalized2_Std_dev ~ PalData[["SCDblot_cutoff"]]$Normalized2_Mean)
lm.normZ <- lm(PalData[["SCDblot_cutoff"]]$NormalizedZ_Std_dev ~ PalData[["SCDblot_cutoff"]]$NormalizedZ_Mean)
