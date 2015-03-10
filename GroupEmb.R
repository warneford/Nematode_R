# Function to group embryos by axis orientation
# input arguments are list of data.frames, 
# name of lineage to identify strain in filenames,
# and directory containing Aux_info files

GroupEmb <- function(listdf, lineage, directory) {
  
  # Generate list of embryos grouped by axis
  # Enter desired axis groupings, "L" will extract all axis entries ending with "L"
  EmbOrientationRL <- c("R", "L") 
  
  # Generate annotation file for SCD data with auxillary information for desired worm strain
  Aux_info <- RepAuxfiles(lineage, directory)
  
  
  EmbAxisList <- list()
  EmbAxisList <- lapply(EmbOrientationRL, function(x) 
  {Aux_info[grep(paste0("^.+",x, "$"), Aux_info$axis), "name"]})
  names(EmbAxisList) <- EmbOrientationRL
  
  # Group SCD data by embryo orientation
  EmbAxisData <- lapply(EmbOrientationRL, function(x)  {
    listdf$SCD_Data[EmbAxisList[[x]]] })
  
  names(EmbAxisData) <- EmbOrientationRL 
  
  return(EmbAxisData)}