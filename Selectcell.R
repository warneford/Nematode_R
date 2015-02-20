# Function to extract data for specific cell or vector of cell names and compute summary statistics
# eg. ("AB", "ABp", "ABa" etc) drawing from normalized blot dataframe.
# namecol specifies how many columns at left are labels
Selectcell <- function(Cell_names, blotdf) {


# Pulls out all timepoints from blot data frame for desired Cell
  Sample_blot <-blotdf[blotdf$ID %in% Cell_names ,]

return(Sample_blot)}

