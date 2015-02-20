# Function to plot expression of cell over course of its lifespan
# Takes single argument of cell name in character form 
# and dataframe of normalized blot data to draw from.
# namecol specifies how many columns at left are labels and should be excluded from calculations
Plotcell <- function(CellID, df = PalData$EmbOr_NormalizedZ_blot$Both, namecol = 2) {
  
# extracts relevant rows from data frame 
foo <- Selectcell(CellID, df)

# compute summary statistics for each timepoint
foo2 <- cellDFsummary(foo, omit = 2, IDcol = 1, Timecol = 2)

# generates plot of cell data
# library(ggplot2)
# ggplot(foo2, aes(x = Time, ymin=Mean-SD, ymax=Mean+SD)) + 
  #geom_pointrange(aes(y = Mean, col = "Mean")) +
  #geom_errorbar(width=0.5, colour = "dark blue") +
  #geom_point(aes(y = CV, col = "CV")) +
  #ggtitle(paste(foo2$ID[1]," gene expression over cell lifespan")) +
  #scale_color_discrete(name="Legend") 

par(mar=c(5,4,4,4))
plot(x =foo2$Time, y = foo2$Mean, xlab="Time",ylab="",pch=5, col="blue", 
     ylim=c(0, max(foo2$Mean + foo2$SD)))
epsilon = 0.3
segments(foo2$Time, foo2$Mean-foo2$SD,foo2$Time, foo2$Mean+foo2$SD)
segments(foo2$Time-epsilon, foo2$Mean-foo2$SD,foo2$Time+epsilon, foo2$Mean-foo2$SD)
segments(foo2$Time-epsilon, foo2$Mean+foo2$SD,foo2$Time+epsilon, foo2$Mean+foo2$SD)
mtext("Mean Expression",side=2,line=2,col="blue")
title(paste("Cell ", CellID," Pal-1 expression over lifespan"))

par(new=T)
plot(foo2$Time, foo2$CV,axes=F,xlab="",ylab="",pch=2,col="red")
axis(side=4)
mtext("CV",side=4,line=2,col="red")}
