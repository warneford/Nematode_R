# Function to plot expression of cell over course of its lifespan
# Takes single argument of cell name in character form 
# and dataframe of normalized blot data to draw from.
# ancestors specifies whether to plot all previous cells in lineage
# namecol specifies how many columns at left are labels and should be excluded from calculations
Plotcell <- function(CellID, df = PalData$EmbOr_NormalizedZ_blot$Both, namecol = 2, ancestors = FALSE) {
  
# extracts relevant rows from data frame 
if (ancestors == TRUE) {
  names <- GetParents(CellID)
  names <- c(names, CellID)
  foo <- Selectcell(names, df)
} else {
  foo <- Selectcell(CellID, df) }
  
# compute summary statistics for each timepoint
foo2 <- cellDFsummary(foo, omit = namecol, IDcol = 1, Timecol = 2)

par(mar=c(5,4,4,4))
plot(x =foo2$Time, y = foo2$Mean, xlab="Time",ylab="",pch=20, col=foo2$ID, 
     ylim=c(0, max(foo2$Mean + foo2$SD, na.rm = TRUE)))

legend('topleft',title = "Cell", legend = unique(foo2$ID), col=unique(foo2$ID), pch=20)
epsilon = 0.3
segments(foo2$Time, foo2$Mean-foo2$SD, foo2$Time, foo2$Mean+foo2$SD)
segments(foo2$Time-epsilon, foo2$Mean-foo2$SD, foo2$Time+epsilon, foo2$Mean-foo2$SD)
segments(foo2$Time-epsilon, foo2$Mean+foo2$SD,foo2$Time+epsilon, foo2$Mean+foo2$SD)

mtext("Mean Expression",side=2,line=2)

if (ancestors == TRUE) {plotid <- "lineage"
} else {plotid <- "lifespan"}

title(paste("Cell", CellID, "Pal-1 expression over", plotid))

par(new=T)
plot(foo2$Time, foo2$CV,axes=F,xlab="",ylab="",pch=23, bg="orange",col="orange", ylim=c(0,1), cex = 0.5)
axis(side=4)
mtext("CV",side=4,line=2,col="red")}
