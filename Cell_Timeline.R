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
PalData$SortAvCellBlot <- lapply(PalData$AverageCellblot, function(x) {Sortblot(df = x, LoMean = 50, LoCV = 0.5,TimeMax = 500)})

# Reorder factors of cell names in ascending Mean blot order
PalData$SortAvCellBlot <- lapply(PalData$SortAvCellBlot, function(df) {cbind(ID = factor(df$ID, levels=df$ID[order(df$Mean)], ordered = TRUE), df[-c(1)])})

View(PalData$SortAvCellBlot$Both)
# Plots all cells Mean and CV values
library(ggplot2)
P1 <- ggplot(PalData$SortAvCellBlot$R, aes(x = ID, y=value, colour = Variable)) + 
  geom_point(aes(y=Mean, col="Mean")) +
  geom_point(aes(y = CV, col = "CV")) 


# Plots dual ordinate plot of Averaged blot data (Mean and CV)

# Select Indices of Cells to plot
PlotRange <- c(43:53)

par(mar=c(5,4,4,4))
plot(x = PlotRange, y = PalData$SortAvCellBlot$Both$Mean[PlotRange], xlab="", ylab="",
     ylim=c(0, max(PalData$SortAvCellBlot$Both$Mean[PlotRange])), pch=20, col ="blue", axes=FALSE )
axis(2)
axis(1, at=seq_along(PalData$SortAvCellBlot$Both$Mean),labels=as.character(PalData$SortAvCellBlot$Both$ID), las=2)
mtext("Mean Expression",side=2,line=2,col="blue")
title(paste("Cells with high Pal-1 expression"))

par(new=T)
plot(1:length(PalData$SortAvCellBlot$Both$Mean[PlotRange]), PalData$SortAvCellBlot$Both$CV[PlotRange],axes=F,xlab="",ylab="",pch=23, bg = "red", col="red")
axis(side=4)
mtext("CV",side=4,line=2,col="red")


# plots cell Eal reporter expression over cell lifetime
Plotcell("Dpppa")




