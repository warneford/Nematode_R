# Produce cell aggregated expression data plotted by chronological order.

# generate list of cell names
CellID <- levels(Data$SCD_blot$cell)

# linearly normalize embryo orientation-sorted blot values in each experiment to middle Z plane
Zcorr = 0.027 # Z plane linear normalization factor
 
Data[["EmbOr_NormalizedZ_blot"]] <-  lapply(EmbOrientationRL, 
       function(lst) {cbind(ID = Data$SCD_blot$cell, Time = Data$SCD_blot$cellTime, data.frame(lapply(EmbAxisData[[lst]], 
       function(df) { Znorm <- (33-df$zraw)*Zcorr + 1
        df$blot*Znorm})))}) 
        rm(Zcorr)

names(Data$EmbOr_NormalizedZ_blot) <- EmbOrientationRL

# Combine L and R Z-normalized blot data 
Data$EmbOr_NormalizedZ_blot$Both <- cbind(Data$EmbOr_NormalizedZ_blot$R, Data$EmbOr_NormalizedZ_blot$L[-c(1,2)])
EmbOrientationRLB <- c(EmbOrientationRL, "Both")


# Collapse Z normalized blot data by cell identity.
Data$cellblot <- lapply(Data$EmbOr_NormalizedZ_blot, function(df) {aggregate(df[-c(1, 2)], list(Cell = Data$SCD_blot$cell), mean, na.action = na.exclude)})

# Add first time point to each cell average entry
CellStartTimes <- unlist(lapply(CellID, function(Cell) {Data$EmbOr_NormalizedZ_blot$Both$Time[Data$EmbOr_NormalizedZ_blot$Both$ID %in% Cell][1]}))
Data$cellblot <- lapply(Data$cellblot, function(df) {cbind(df[1], Time = CellStartTimes, df[-c(1)])})
rm(CellStartTimes, CellID)
names(Data$cellblot) <- EmbOrientationRLB

# summary of cell averaged blot values across all replicates 
Data$AverageCellblot <- lapply(Data$cellblot, cellDFsummary)
names(Data$AverageCellblot) <- EmbOrientationRLB

# Subset Averaged blot data for highly-expressing cells and larger CV values
Data$SortAvCellBlot <- lapply(Data$AverageCellblot, function(x) {Sortblot(df = x, LoMean = 100, LoCV = 0,)})
