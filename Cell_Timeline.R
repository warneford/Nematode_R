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

# Subset for cells expressing gene at early time points
PalData$HiAverageCellblot <- lapply(PalData$AverageCellblot, function(df) {subset(df, Mean > 50 & Time < 300)})

# Sort in ascending order of expression
PalData$HiAverageCellblot <- lapply(PalData$HiAverageCellblot, function(df) { df[order(df$Mean) ,] })

# List cells with Coefficient of variation of blot values > 1
Varcells <- lapply(PalData$HiAverageCellblot, function(df) {df$ID[df$CV > 1 & (is.na(df$CV) == FALSE)]})


# Plot mean and CV of variable cells
VarcellSub <- Selectcell(Varcells$Both, PalData$HiAverageCellblot$Both)

# Reorder factors of cell names in ascending Mean blot order
VarcellSub$IDn <- factor(VarcellSub$ID, levels=VarcellSub$ID[order(VarcellSub$Mean)], ordered=TRUE)


# Plots all cells Mean and CV values
library(ggplot2)
P1 <- ggplot(VarcellSub[10:15 ,], aes(x = IDn, y=value, colour = Variable)) + 
  # geom_point(aes(y=Mean, col="Mean")) +
  geom_point(aes(y = CV, col = "CV")) 
P1

P2 <- ggplot(VarcellSub) +  
  geom_errorbar(mapping=aes(x=IDn, ymin=Mean-SD, ymax=Mean+SD), width=0.2, size=1, colour="red") +
  geom_point(mapping=aes(x=IDn, y=Mean), size=4, shape=21, fill="white") +
  geom_point(aes(x=IDn, y = CV, col = "CV"), colour = "blue") +
  ggtitle("Mean Gene Expression versus Cell Identity")

Plotcell("ABprapppapa")
