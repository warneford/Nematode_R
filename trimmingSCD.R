# Specify columns to remove from data
drops <- c()
PalData[["SCD_Data"]] <- lapply (PalData[["SCD_Data"]], function(x) {x[,!(names(x) %in% drops)]})

# Find missing values and assign NA (where no x and y coordinates given | gweight = 0)
PalData[["SCD_Data"]] <- lapply(PalData[["SCD_Data"]], function(df) {within(df, blot[x==0 & y==0 | gweight==0] <- NA)})
PalData[["SCD_Data"]] <- lapply(PalData[["SCD_Data"]], function(df) {within(df, gweight[x==0 & y==0 | gweight==0] <- NA)})

# Combine all blot data 
PalData[["SCD_blot"]] <- cbind(PalData[["SCD_Data"]][[1]][,c(1,2)], as.data.frame(lapply(PalData[["SCD_Data"]], function(x) {x$blot})))
names(PalData[["SCD_blot"]]) <- gsub("X", "", names(PalData[["SCD_blot"]]))


# Combine all gweight data
PalData[["gweight"]] <- cbind(PalData[["SCD_Data"]][[1]][,c(1,2)], as.data.frame(lapply(PalData[["SCD_Data"]], function(x) {x$gweight})))

# calculate mean un-normalized gweight values (Method 1)
PalData[["Mean_gweight"]] <- cbind(PalData[["SCD_Data"]][[1]][,c(1,2)], as.data.frame(apply(PalData[["gweight"]][-c(1,2)], 1, function(x) {mean(x, na.rm=TRUE)})))

# Normalize Gweight values for cell volume (Method 2)
PalData[["Normalized_gweight"]] <- cbind(PalData[["SCD_Data"]][[1]][,c(1,2)], as.data.frame(lapply(PalData[["SCD_Data"]], function(x) {x$gweight/(x$size^3)})))

# calculate mean, normalized gweight values
PalData[["Mean_normalized_gweight"]] <- cbind(PalData[["SCD_Data"]][[1]][,c(1,2)], as.data.frame(apply(PalData[["Normalized_gweight"]][-c(1,2)], 1, function(x) {mean(x, na.rm=TRUE)})))

# linearly normalizes blot values in each experiment to middle Z plane (Method Z)
Zcorr = 0.027 # Z plane linear normalization factor
PalData[["NormalizedZ_blot"]] <-  cbind(PalData[["SCD_Data"]][[1]][,c(1,2)], as.data.frame(lapply(PalData[["SCD_Data"]], function(df) {
  Znorm <- (33-df$zraw)*Zcorr + 1
  df$blot*Znorm})))

# normalizes blot values in each experiment to average gweight values (Method 1)
PalData[["Normalized1_blot"]] <- PalData[["SCD_blot"]][, -c(1,2)]/(PalData[["gweight"]][, -c(1,2)]/PalData[["Mean_gweight"]][, -c(1,2)])

# normalizes blot values in each experiment to average gweight values and cell volume (Method 2)
PalData[["Normalized2_blot"]] <- PalData[["SCD_blot"]][, -c(1,2)]/(PalData[["Normalized_gweight"]][, -c(1,2)]/PalData[["Mean_normalized_gweight"]][, -c(1,2)])
