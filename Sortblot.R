# Function that subsets averaged blot data for certain parameter ranges (Mean, CV, Time)
Sortblot <-function(LoMean = 0, HiMean = Inf, LoCV = 0, HiCV = Inf, TimeMax = Inf, df) {
  
# Subset cells
df <- subset(df, (Mean > LoMean) & (Mean < HiMean) & (Time < TimeMax))
outdf <- subset(df,  (CV > LoCV) & (CV < HiCV))
return(outdf)}
