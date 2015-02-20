# Function to plot expression data timepoints for specific cell ("AB", "ABp", "ABa" etc) 
# drawing from normalized blot dataframe.
# namecol specifies how many columns at left are labels
Plotcell <-function(Cell_name, blotdf, namecol = 1) {


# Pulls out all timepoints from blot data frame for desired Cell
sample_blot <-blotdf[blotdf$Cell == Cell_name ,]

# computes summary statistics for each time point of the cell of interest
Sample_out <- cellDFtimepts(sample_blot, omit = namecol)

return(Sample_out)}


