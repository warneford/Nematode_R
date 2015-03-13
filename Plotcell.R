# Function to plot expression of cell over course of its lifespan
# Takes single argument of cell name in character form 
# and dataframe of normalized blot data to draw from.
# sdf specifies source data structure from which df is drawn, used to pass annotations to plot options
# ancestors specifies whether to plot all previous cells in lineage
# namecol specifies how many columns at left are labels and should be excluded from calculations
# Option outdata specifies whether to output relevant rows from argument data.frame to dataframe
Plotcell <- function(CellID, df, sdf, namecol = 2, ancestors = FALSE, outdata = FALSE) {
  
# extracts relevant rows from data frame 
if (ancestors == TRUE) {
  names <- GetParents(CellID)
  names <- c(names, CellID)
  foo <- Selectcell(names, df, Chronological = TRUE)
} else {
  # for viewing single cell expression data
  foo <- Selectcell(CellID, df, Chronological = TRUE) 
    }


# Tabulate number of replicates at each time point
  # Generate index of timepoints from subsetted data
  IndexTm <- 1:nrow(foo)
  NumReplicates <- c()

        for (i in 1:nrow(foo)) {
            temp <- foo[i,-c(1,2)]
            nrep <- length(temp[is.na(temp) == FALSE])
            NumReplicates <- c(NumReplicates, nrep)}  


# compute summary statistics for each timepoint
foo2 <- cellDFsummary(foo, omit = namecol, IDcol = 1, Timecol = 2)
foo2$NumReplicates <- NumReplicates


par(mar=c(5,4,4,4))
plot(x =foo2$Time, y = foo2$Mean, xlab="Time",ylab="",pch=20, col=foo2$ID, 
     ylim=c(0, max(foo2$Mean + foo2$SD, na.rm = TRUE)))

legend('topleft',title = "Cell", legend = unique(foo2$ID), col=unique(foo2$ID), pch=20)
epsilon = 0.3
segments(foo2$Time, foo2$Mean-foo2$SD, foo2$Time, foo2$Mean+foo2$SD)
segments(foo2$Time-epsilon, foo2$Mean-foo2$SD, foo2$Time+epsilon, foo2$Mean-foo2$SD)
segments(foo2$Time-epsilon, foo2$Mean+foo2$SD,foo2$Time+epsilon, foo2$Mean+foo2$SD)

mtext("Normalized Mean Expression (AU)",side=2,line=2)

# Plot number of replicates at each time point for single cell visualization
if (ancestors == FALSE) {
  text(foo2$Time, foo2$Mean*0.2, labels = foo2$NumReplicates, cex = 0.7 )}




if (ancestors == TRUE) {plotid <- "lineage"
} else {plotid <- "lifespan"}

title(paste(sdf$Directory, "Cell", CellID, sdf$repID, "expression over", plotid))

par(new=T)
plot(foo2$Time, foo2$CV,axes=F,xlab="",ylab="",pch=23, bg="orange",col="orange", ylim=c(0,1), cex = 0.5)
axis(side=4)
mtext("CV",side=4,line=2,col="orange")


if (outdata == TRUE) {return(foo2)}

}