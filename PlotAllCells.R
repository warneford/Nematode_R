# Function to plot Mean and CV data for cells that highly express reporter gene.
# LoCell and HiCell indicate lower and upper bound of cells to plot, by default PlotAllCells
# will plot all cells. LoCell must be 1 or greater. 
# sdf specifies root of data frame
# Sort <- c("blot", "time", "CV", "lineage"). This sorts the cells either by increasing mean blot,
# chronological order, by increasing coefficient of variation, or by lineage
# Outnames specifies whether to silence plot output and simply output desired cell names in a vector
PlotAllCells <- function(LoCell = 1, HiCell = length(df$ID), df, sdf,  sort = "blot", outnames = FALSE) {

if (sort == "blot") # sort cells in ascending mean blot value and reorder cell name factors
  { df <- df[order(df$Mean) ,]  
    df <- cbind(ID = factor(df$ID, levels=df$ID[order(df$Mean)], ordered = TRUE), df[-c(1)])
    
} else if (sort == "time") # sort cells chronologically and reorder cell name factors
  { df <- df[order(df$Time) ,]  
    df$ID <- factor(df$ID, levels=df$ID[order(df$Time)], ordered = TRUE)
    
} else if (sort == "CV") # sort cells chronologically and reorder cell name factors
  { df <- df[order(df$CV) ,]  
    df <- cbind(ID = factor(df$ID, levels=df$ID[order(df$CV)], ordered = TRUE), df[-c(1)])
    
} else if (sort == "lineage") # sort cells by lineage and reorder cell name factors
{ df <- df[order(df$ID) ,]  
  df <- cbind(ID = factor(df$ID, levels=df$ID[order(df$ID)], ordered = TRUE), df[-c(1)])
  
}
PlotRange <- c(LoCell:HiCell)
# output vector of cell names for Plotcell.R
if (outnames == TRUE) {
  foo <- as.character(df$ID[PlotRange])
    
    # remove cell names with duplicate lineages
    for (i in 1:length(foo))
         {TempParent <- GetParents(foo[i])
          foo <- foo[! (foo %in% TempParent)]}
    return(foo)
}


par(mar=c(6,4,4,4))
plot(x = PlotRange, y = df$Mean[PlotRange], xlab="", ylab="",
     ylim=c(0, max(df$Mean[PlotRange])), pch=20, col ="blue", axes=FALSE )
axis(2)
axis(1, at=seq_along(df$Mean),labels=as.character(df$ID), las=2)
mtext("Mean Expression",side=2,line=2,col="blue")
title(paste("Cells with high", sdf$repID, "expression"))

par(new=T)
plot(1:length(df$Mean[PlotRange]), df$CV[PlotRange],axes=F,xlab="",ylab="",pch=23, bg = "red",cex = 0.5,  
     ylim=c(0, 2), col="red")
axis(side=4)
mtext("CV",side=4,line=2,col="red")}