# Produce cell aggregated expression data plotted by chronological order.


# generate list of cell names
CellID <- levels(PalData$SCD_blot$cell)

# linearly normalize embryo orientation-sorted blot values in each experiment to middle Z plane
Zcorr = 0.027 # Z plane linear normalization factor
 
PalData[["EmbOr_NormalizedZ_blot"]] <-  lapply(EmbOrientationRL, 
       function(lst) {cbind(ID = PalData$SCD_blot$cell, Time = PalData$SCD_blot$cellTime, data.frame(lapply(EmbAxisData[[lst]], 
       function(df) { Znorm <- (33-df$zraw)*Zcorr + 1
        df$blot*Znorm})))})   

# Combine L and R Z-normalized blot data 
PalData$EmbOr_NormalizedZ_blot$Both <- cbind(PalData$EmbOr_NormalizedZ_blot$R, PalData$EmbOr_NormalizedZ_blot$L[-c(1,2)])
EmbOrientationRLB <- c(EmbOrientationRL, "Both")


# Collapse Z normalized blot data by cell identity.
PalData$cellblot <- lapply(PalData$EmbOr_NormalizedZ_blot, function(df) {aggregate(df[-c(1, 2)], list(Cell = PalData$SCD_blot$cell), mean, na.action = na.exclude)})
names(PalData$cellblot) <- EmbOrientationRLB


# summary of cell averaged blot values across all replicates 
PalData$AverageCellblot <- lapply(PalData$cellblot, cellDFsummary)
names(PalData$AverageCellblot) <- EmbOrientationRLB


# Subset Averaged blot data for highly-expressing cells and larger CV values
PalData$SortAvCellBlot <- lapply(PalData$AverageCellblot, function(x) {Sortblot(df = x, LoMean = 50, LoCV = 0, HiCV = 1.0,TimeMax = 500)})

# Reorder factors of cell names in ascending Mean blot order
PalData$SortAvCellBlot <- lapply(PalData$SortAvCellBlot, function(df) {cbind(ID = factor(df$ID, levels=df$ID[order(df$Mean)], ordered = TRUE), df[-c(1)])})


# Plots dual ordinate plot of Averaged blot data (Mean and CV)
PlotAllCells(LoCell = 50, HiCell = 66, df = PalData$SortAvCellBlot$Both)

# plots specific cell reporter expression over cell lifetime
Plotcell("ABplp")

View(PalData$SortAvCellBlot$Both)



