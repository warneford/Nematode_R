# Function to output character vector of daughter cells from input argument cell 
# Logical option Immediate specifies whether to output immediate 2 daughter cells
# or entire lineage
GetDaughters <- function(Cell, Immediate = TRUE) {
    Daughters <- c()
    
    
# load required functions & variables
  source("GetParents.R")
  source("GetParent.R")
  load("Cell_names.RData")


for ( i in 1:length(AllCells)) {
      
  if (Immediate == TRUE) {Parent <- GetParent(AllCells[i])}
  
  else {Parent <- GetParents(AllCells[i])}
  
    if (Cell %in% Parent) {Daughters <- c(Daughters, AllCells[i])}
    } 

return(Daughters)}
