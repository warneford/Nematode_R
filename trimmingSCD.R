# Specify columns to remove from data
drops <- c()
Data[["SCD_Data"]] <- lapply (Data[["SCD_Data"]], function(x) {x[,!(names(x) %in% drops)]})
rm(drops)

# Find missing values and assign NA (where no x and y coordinates given | gweight = 0)
Data[["SCD_Data"]] <- lapply(Data[["SCD_Data"]], function(df) {within(df, blot[x==0 & y==0 | gweight==0] <- NA)})
Data[["SCD_Data"]] <- lapply(Data[["SCD_Data"]], function(df) {within(df, gweight[x==0 & y==0 | gweight==0] <- NA)})

# Combine all blot data 
Data[["SCD_blot"]] <- cbind(Data[["SCD_Data"]][[1]][,c(1,2)], as.data.frame(lapply(Data[["SCD_Data"]], function(x) {x$blot})))
names(Data[["SCD_blot"]]) <- gsub("X", "", names(Data[["SCD_blot"]]))

# Generate time column for each cell
library(stringr)
Data$SCD_blot$cellTime <- as.numeric(str_split_fixed(Data$SCD_blot$cellTime, ":", 2)[,2])

# Combine all gweight data
Data[["gweight"]] <- cbind(Data[["SCD_Data"]][[1]][,c(1,2)], as.data.frame(lapply(Data[["SCD_Data"]], function(x) {x$gweight})))

# calculate mean un-normalized gweight values (Method 1)
Data[["Mean_gweight"]] <- cbind(Data[["SCD_Data"]][[1]][,c(1,2)], as.data.frame(apply(Data[["gweight"]][-c(1,2)], 1, function(x) {mean(x, na.rm=TRUE)})))

# Normalize Gweight values for cell volume (Method 2)
Data[["Normalized_gweight"]] <- cbind(Data[["SCD_Data"]][[1]][,c(1,2)], as.data.frame(lapply(Data[["SCD_Data"]], function(x) {x$gweight/(x$size^3)})))

# calculate mean, normalized gweight values
Data[["Mean_normalized_gweight"]] <- cbind(Data[["SCD_Data"]][[1]][,c(1,2)], as.data.frame(apply(Data[["Normalized_gweight"]][-c(1,2)], 1, function(x) {mean(x, na.rm=TRUE)})))


# Generate Z normalization factor
Zcorr <- OptimZ(Data$SCD_Data)

# linearly normalizes blot values in each experiment to middle Z plane (Method Z)
Data[["NormalizedZ_blot"]] <-  cbind(Data[["SCD_blot"]][,c(1,2)], as.data.frame(lapply(Data[["SCD_Data"]], function(df) {
  Znorm <- (33-df$zraw)*Zcorr + 1
  df$blot*Znorm})))

# normalizes blot values in each experiment to average gweight values (Method 1)
Data[["Normalized1_blot"]] <- cbind(Data$SCD_blot[,c(1,2)], Data[["SCD_blot"]][, -c(1,2)]/(Data[["gweight"]][, -c(1,2)]/Data[["Mean_gweight"]][, -c(1,2)]))

# normalizes blot values in each experiment to average gweight values and cell volume (Method 2)
Data[["Normalized2_blot"]] <- cbind(Data$SCD_blot[,c(1,2)], Data[["SCD_blot"]][, -c(1,2)]/(Data[["Normalized_gweight"]][, -c(1,2)]/Data[["Mean_normalized_gweight"]][, -c(1,2)]))
