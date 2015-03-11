# Function to perform Data extraction, trimming, and normalization, 
# lineage corresponds to unique specifier in filenames, used for parsing.
# Rawdir designates raw data source directory
SCDprocess <- function(lineage = "RW10890", Rawdir) {
  
  # Import SCD data  
  listdf <- ImportSCD(Rawdir)
  
  # Trim data
  listdf <- Trimming(listdf, lineage, Rawdir)
  
  # Group Embryos by Orientation
  groupdf <- GroupEmb(listdf)
  
  # Screen cells for high gene expression &
  listdf <- BlotTime(listdf, groupdf)
  
  # Record data type
  listdf$lineage = lineage
  listdf$Directory = Rawdir
  
  return(listdf)}