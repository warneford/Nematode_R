# Wrapper of Sortblot.R to handle lists of data.frames
SortBlot2 <- function(listdf, MeanLo = 0, MeanHi = Inf, CVLo = 0, CVHi = Inf) {
  listdf$SortAvCellBlot <- lapply(listdf$AverageCellblot2, function(x){
                            Sortblot(df = x, 
                                     LoMean = MeanLo, 
                                     HiMean =  MeanHi, 
                                     LoCV = CVLo, 
                                     HiCV = CVHi)})
return(listdf)}
  
  
  
  