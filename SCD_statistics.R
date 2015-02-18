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
EmbOrientation <- c("R", "L") # Enter desired axis groupings, "L" will extract all axis entries ending with "L"
EmbAxisList <- list()
EmbAxisList <- lapply(EmbOrientation, function(x) 
  {AuxRW10890[grep(paste0("^.+",x, "$"), AuxRW10890$axis), "name"]})
names(EmbAxisList) <- EmbOrientation

# group embryos by axis orientation
EmbAxisblot <- lapply(EmbAxisList, function(x) {  
PalData[["SCD_blot"]][, names(PalData$SCD_blot) %in% x]})
names(EmbAxisGroup) <- EmbOrientation
       
# Compute statistics for each axis orientation subset
# Right
PalData[["SCDblotsummary"]][,"NormalizedR_Mean"] <- apply(EmbAxisGroup$R[-c(1,2)], 1, function(x) {mean(x, na.rm=TRUE)})
PalData[["SCDblotsummary"]][,"NormalizedR_Variance"] <- apply(EmbAxisGroup$R[-c(1,2)], 1, function(x) {var(x, na.rm=TRUE)})
PalData[["SCDblotsummary"]][,"NormalizedR_Std_dev"] <- apply(EmbAxisGroup$R[-c(1,2)], 1, function(x) {sd(x, na.rm=TRUE)})

# Left
PalData[["SCDblotsummary"]][,"NormalizedL_Mean"] <- apply(EmbAxisGroup$L[-c(1,2)], 1, function(x) {mean(x, na.rm=TRUE)})
PalData[["SCDblotsummary"]][,"NormalizedL_Variance"] <- apply(EmbAxisGroup$L[-c(1,2)], 1, function(x) {var(x, na.rm=TRUE)})
PalData[["SCDblotsummary"]][,"NormalizedL_Std_dev"] <- apply(EmbAxisGroup$L[-c(1,2)], 1, function(x) {sd(x, na.rm=TRUE)})


# Rank pal-1 data by Standard deviation (Method 1)
PalData[["Rankblotsummary"]] <- PalData[["SCDblotsummary"]][order(PalData$SCDblotsummary$NormalizedZ_Std_dev, na.last = TRUE, decreasing = TRUE) ,]

# Set lower cutoff for mean blot value
PalData[["SCDblot_cutoff"]] <- subset(PalData[["SCDblotsummary"]], (NormalizedZ_Mean > 100))

# remove infinite normalized mean values
PalData[["SCDblot_cutoff"]] <- subset(PalData[["SCDblot_cutoff"]], !(is.infinite(Normalized1_Mean) | is.infinite(Normalized2_Mean)))

# Compute linear regression
lm.reg <- lm(PalData[["SCDblot_cutoff"]]$Std_dev ~ PalData[["SCDblot_cutoff"]]$Mean)

lm.norm1 <- lm(PalData[["SCDblot_cutoff"]]$Normalized1_Std_dev ~ PalData[["SCDblot_cutoff"]]$Normalized1_Mean)
lm.norm2 <- lm(PalData[["SCDblot_cutoff"]]$Normalized2_Std_dev ~ PalData[["SCDblot_cutoff"]]$Normalized2_Mean)
lm.normZ <- lm(PalData[["SCDblot_cutoff"]]$NormalizedZ_Std_dev ~ PalData[["SCDblot_cutoff"]]$NormalizedZ_Mean)
lm.normR <- lm(PalData[["SCDblot_cutoff"]]$NormalizedR_Std_dev ~ PalData[["SCDblot_cutoff"]]$NormalizedR_Mean)
lm.normL <- lm(PalData[["SCDblot_cutoff"]]$NormalizedL_Std_dev ~ PalData[["SCDblot_cutoff"]]$NormalizedL_Mean)

# catch errors
errorcases <- subset(PalData[["SCDblot_cutoff"]], is.na(Normalized1_Variance) & (!is.na(Variance)))
