# Function to plot expression of cell over course of its lifespan
# Takes single argument of cell name in character form 
# and dataframe of normalized blot data to draw from.
# namecol specifies how many columns at left are labels and should be excluded from calculations
Plotcell <- function(CellID, df, namecol = 2) {
  
# extracts relevant rows from data frame 
foo <- Selectcell(CellID, df)

# compute summary statistics for each timepoint
foo2 <- cellDFsummary(foo, omit = 2, IDcol = 1, Timecol = 2)

# generates plot of cell data
library(ggplot2)
ggplot(foo2, aes(x = Time, ymin=Mean-SD, ymax=Mean+SD)) + 
  geom_pointrange(aes(y = Mean, col = "Mean")) +
  geom_point(aes(y = CV, col = "CV")) +
  ggtitle(paste(foo2$ID[1]," gene expression over cell lifespan")) +
  scale_color_discrete(name="Legend") }
