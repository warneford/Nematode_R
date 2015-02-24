# Produce cell aggregated expression data plotted by chronological order.


# generate list of cell names
CellID <- levels(Data$SCD_blot$cell)

# linearly normalize embryo orientation-sorted blot values in each experiment to middle Z plane
Zcorr = 0.027 # Z plane linear normalization factor
 
Data[["EmbOr_NormalizedZ_blot"]] <-  lapply(EmbOrientationRL, 
       function(lst) {cbind(ID = Data$SCD_blot$cell, Time = Data$SCD_blot$cellTime, data.frame(lapply(EmbAxisData[[lst]], 
       function(df) { Znorm <- (33-df$zraw)*Zcorr + 1
        df$blot*Znorm})))}) 
names(Data$EmbOr_NormalizedZ_blot) <- EmbOrientationRL

# Combine L and R Z-normalized blot data 
Data$EmbOr_NormalizedZ_blot$Both <- cbind(Data$EmbOr_NormalizedZ_blot$R, Data$EmbOr_NormalizedZ_blot$L[-c(1,2)])
EmbOrientationRLB <- c(EmbOrientationRL, "Both")


# Collapse Z normalized blot data by cell identity.
Data$cellblot <- lapply(Data$EmbOr_NormalizedZ_blot, function(df) {aggregate(df[-c(1, 2)], list(Cell = Data$SCD_blot$cell), mean, na.action = na.exclude)})
names(Data$cellblot) <- EmbOrientationRLB

# summary of cell averaged blot values across all replicates 
Data$AverageCellblot <- lapply(Data$cellblot, cellDFsummary)
names(Data$AverageCellblot) <- EmbOrientationRLB


# Subset Averaged blot data for highly-expressing cells and larger CV values
Data$SortAvCellBlot <- lapply(Data$AverageCellblot, function(x) {Sortblot(df = x, LoMean = 50, LoCV = 0, HiCV = 1.0,TimeMax = 500)})

# Reorder factors of cell names in ascending Mean blot order
Data$SortAvCellBlot <- lapply(Data$SortAvCellBlot, function(df) {cbind(ID = factor(df$ID, levels=df$ID[order(df$Mean)], ordered = TRUE), df[-c(1)])})
