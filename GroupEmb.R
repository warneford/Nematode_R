# Function to group embryos by axis orientation
# input argument is data structure that is output from trimmingSCD.R

GroupEmb <- function(listdf) {
  # Generate list of embryos grouped by axis
  # Enter desired axis groupings, "L" will extract all axis entries ending with "L"
  EmbOrientationRL <- c("R", "L") 
  
  EmbAxisList <- list()
  EmbAxisList <- lapply(EmbOrientationRL, function(x) 
  {listdf$Aux_info[grep(paste0("^.+",x, "$"), listdf$Aux_info$axis), "name"]})
  names(EmbAxisList) <- EmbOrientationRL
  
  
  # Group SCD data by embryo orientation
  EmbAxisData <- lapply(EmbOrientationRL, function(x)  {
      listdf$SCD_Data[EmbAxisList[[x]]] })
  
  names(EmbAxisData) <- EmbOrientationRL 
  
  return(EmbAxisData)}