# Produce cell aggregated expression data plotted by chronological order.

# generate list of cell names
CellID <- levels(Data$SCD_blot$cell)

# linearly normalize embryo orientation-sorted blot values in each experiment to middle Z plane
Data[["EmbOr_NormalizedZ_blot"]] <-  lapply(EmbOrientationRL, 
       function(lst) {cbind(ID = Data$SCD_blot$cell, Time = Data$SCD_blot$cellTime, data.frame(lapply(EmbAxisData[[lst]], 
       function(df) { Znorm <- (33-df$zraw)*Zcorr + 1
        df$blot*Znorm})))}) 
        names(Data$EmbOr_NormalizedZ_blot) <- EmbOrientationRL
        rm(Zcorr)

# Combine L and R Z-normalized blot data 
Data$EmbOr_NormalizedZ_blot$Both <- cbind(Data$EmbOr_NormalizedZ_blot$R, Data$EmbOr_NormalizedZ_blot$L[-c(1,2)])
EmbOrientationRLB <- c(EmbOrientationRL, "Both")

# Collapse Z-normalized blot data by cell identity.
Data$cellblot <- lapply(Data$EmbOr_NormalizedZ_blot, function(df) {aggregate(df[-c(1, 2)], list(Cell = Data$SCD_blot$cell), mean, na.action = na.exclude)})

# Normalize embryo blot data by raw blot intensity, relative to reference embryo
Blotscaledf <- lapply(Data$cellblot, Blotscale)
Data$NormZblot <- lapply(EmbOrientationRLB, function(Or) {BlotApply(Data$EmbOr_NormalizedZ_blot[[Or]], Blotscaledf[[Or]])})
names(Data$NormZblot) <- EmbOrientationRLB
rm(Blotscaledf)

# Collapse Z-normalized/blot-normalized blot data by cell identity.
Data$cellblot2 <- lapply(Data$NormZblot, function(df) {aggregate(df[-c(1, 2)], list(Cell = Data$SCD_blot$cell), mean, na.action = na.exclude)})

# Add first time point to each cell average entry
CellStartTimes <- unlist(lapply(CellID, function(Cell) {Data$EmbOr_NormalizedZ_blot$Both$Time[Data$EmbOr_NormalizedZ_blot$Both$ID %in% Cell][1]}))
Data$cellblot2 <- lapply(Data$cellblot2, function(df) {cbind(df[1], Time = CellStartTimes, df[-c(1)])})
rm(CellStartTimes, CellID)
names(Data$cellblot2) <- EmbOrientationRLB

# summary of cell averaged blot values across all replicates 
Data$AverageCellblot <- lapply(Data$cellblot2, cellDFsummary)
names(Data$AverageCellblot) <- EmbOrientationRLB

# Plot Mean versus SD of blot data to assess success of normalization method


df <- Data$AverageCellblot$L
temp <- lm(df$SD ~ df$Mean)
library(ggplot2)
ggplot(df, aes(x=Mean, y=SD)) +
  geom_point() +
  geom_smooth(method=lm, colour="red") +
  geom_text(aes(x = max(df$Mean, na.rm = TRUE)*0.2, y = max(df$SD, na.rm = TRUE), 
                label = paste("R^2 is ", format(summary(temp)$adj.r.squared, digits=4), "slope is", format(coef(temp)[2], digits = 3)))) +
  ggtitle("Z & Blot normalized (L Orientation) Mean Pal-1 Blot Values versus Standard Deviation") 
  rm( df, temp)

# Subset Averaged blot data for highly-expressing cells and larger CV values
Data$SortAvCellBlot <- lapply(Data$AverageCellblot, function(x) {Sortblot(df = x, LoMean = 0, LoCV = 0, HiCV = 0.3)})
