# Function to plot Mean and CV data for cells that highly express reporter gene.
# LoCell and HiCell indicate lower and upper bound of cells to plot, by default PlotAllCells
# will plot all cells. LoCell must be 1 or greater
PlotAllCells <- function(LoCell = 1, HiCell = length(df$ID), df) {

PlotRange <- c(LoCell:HiCell)
par(mar=c(5,4,4,4))
plot(x = PlotRange, y = df$Mean[PlotRange], xlab="", ylab="",
     ylim=c(0, max(df$Mean[PlotRange])), pch=20, col ="blue", axes=FALSE )
axis(2)
axis(1, at=seq_along(df$Mean),labels=as.character(df$ID), las=2)
mtext("Mean Expression",side=2,line=2,col="blue")
title(paste("Cells with high Pal-1 expression"))

par(new=T)
plot(1:length(df$Mean[PlotRange]), df$CV[PlotRange],axes=F,xlab="",ylab="",pch=23, bg = "red", col="red")
axis(side=4)
mtext("CV",side=4,line=2,col="red")}