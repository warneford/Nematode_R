# Produce cell aggregated expression data plotted by chronological order.

# Group SCD data by embryo orientation
EmbAxisData <- lapply(EmbOrientationRL, function(x)  {
  PalData$SCD_Data[EmbAxisList[[x]]] })
  names(EmbAxisData) <- EmbOrientationRL

# generate list of cell names
CellID <- levels(PalData$SCD_blot$cell)

# linearly normalize embryo orientation-sorted blot values in each experiment to middle Z plane
  Zcorr = 0.027 # Z plane linear normalization factor
 
PalData[["EmbOr_NormalizedZ_blot"]] <-  lapply(EmbOrientationRL, 
       function(lst) {cbind(Cell = PalData$SCD_blot$cell, Time = PalData$SCD_blot$cellTime, data.frame(lapply(EmbAxisData[[lst]], 
       function(df) { Znorm <- (33-df$zraw)*Zcorr + 1
        df$blot*Znorm})))})
        
      names(PalData$EmbOr_NormalizedZ_blot) <- EmbOrientationRL

# Combine L and R Z-normalized blot data 
PalData$EmbOr_NormalizedZ_blot$Both <- cbind(PalData$EmbOr_NormalizedZ_blot$R, PalData$EmbOr_NormalizedZ_blot$L[-c(1,2)])
EmbOrientationRLB <- c(EmbOrientationRL, "Both")


# Collapse Z normalized blot data by cell identity.
PalData$cellblot <- lapply(PalData$EmbOr_NormalizedZ_blot, function(df) {aggregate(df[-c(1)], list(Cell = PalData$SCD_blot$cell), mean, na.action = na.exclude)})
names(PalData$cellblot) <- EmbOrientationRLB


# summary of cell averaged blot values across all replicates 
PalData$AverageCellblot <- lapply(PalData$cellblot, cellDFtimepts)
View(PalData$AverageCellblot$Both)

# List cells with Coefficient of variation of blot values > 1
Varcells <- lapply(PalData$AverageCellblot, function(df) {df$ID[df$CV > 1 & is.na(df$CV) == FALSE & df$Mean > 50]})

library(ggplot2)
ggplot(PalData$AverageCellblot$R, aes(x = ID, y = value, color = variable)) + 
  geom_point(aes(y = Mean, col = "Mean")) + 
  geom_point(aes(y = CV, col = "CV"))
