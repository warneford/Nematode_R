# Produce cell aggregated expression data plotted by chronological order.

# Group SCD data by embryo orientation
EmbAxisData <- lapply(EmbOrientation, function(x)  {
  PalData$SCD_Data[EmbAxisList[[x]]] })
  names(EmbAxisData) <- EmbOrientation

# generate list of cell names
CellID <- levels(PalData$SCD_blot$cell)

# linearly normalize embryo orientation-sorted blot values in each experiment to middle Z plane
  Zcorr = 0.027 # Z plane linear normalization factor
  PalData[["EmbOr_NormalizedZ_blot"]] <-  lapply(EmbOrientation, function(lst) {cbind(Cell = PalData$SCD_blot$cell, data.frame(lapply(EmbAxisData[[lst]], 
                                                function(df) { Znorm <- (33-df$zraw)*Zcorr + 1
                                                                      df$blot*Znorm})))})
        names(PalData$EmbOr_NormalizedZ_blot) <- EmbOrientation

# Collapse Z normalized blot data by cell identity.
PalData$cellblot <- aggregate(PalData$NormalizedZ_blot[-c(1,2)], list(Cell = PalData$SCD_blot$cell), mean, na.action =na.exclude)
CellID <- paste(PalData$cellblot$Cell)

# Average blot values across all replicates
PalData$AverageCellblot <- data.frame(Cell = CellID, Mean = apply(PalData[["cellblot"]][-c(1)], 1, mean, na.rm=TRUE), Var = apply(PalData[["cellblot"]][-c(1)], 1, var, na.rm=TRUE))
PalData$AverageCellblot[["CV"]] <- PalData$AverageCellblot$Var/PalData$AverageCellblot$Mean
?var

View(PalData$cellblot)
View(PalData$AverageCellblot)
?apply
