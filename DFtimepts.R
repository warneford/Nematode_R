# function to calculate summary statistics row-wise of a data frame (mean, variance, sd, CV)
# To omit calculation of left most label columns (e.g. "Cell") specify number of columns to ignore, default is 1.
# IDcol specifies which column holds the cell ID information, default is 1.

cellDFtimepts <- function(df, omit = 1, IDcol = 1, Timecol = 2) {

# initialize output file
Output <- data.frame(
      ID = df[, IDcol] ,
      Time = df[, 2] , 
      Mean = apply(df[-c(1:omit)], 1, function(x) {mean(x, na.rm=TRUE)}) ,
      Var  = apply(df[-c(1:omit)], 1, function(x) {var(x, na.rm=TRUE)})  ,
      SD   = apply(df[-c(1:omit)], 1, function(x) {sd(x, na.rm=TRUE)}))

# append CV to data frame
Output$CV <- Output$SD/Output$Mean

# Output
return(Output)}