# Function that subsets averaged blot data for certain parameter ranges (Mean, CV, Time)
Sortblot <-function(LoMean = 0, HiMean = Inf, LoCV, HiCV = Inf, TimeMax = Inf, df) {
  
# Subset cells
sortblot <- subset(df, (Mean > LoMean) & (Mean < HiMean) & (CV > LoCV) & (CV < HiCV) & (Time < TimeMax))

return(sortblot)}
