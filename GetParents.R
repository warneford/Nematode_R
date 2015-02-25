# Outputs a character vector of all ancestor cells of argument cell in chronological order
GetParents <- function(Cell) {
  Parents <- character(length = nchar(Cell) + 10)
  
  foo <- Cell
  i = 1
  
  while (is.na(foo) == FALSE)
    { Parents[i] <- GetParent(foo)
      foo <- Parents[i]
      i = i+1}
  
  # Trim NAs and empty values from output
  Parents <- na.omit(Parents[Parents != ""])
  
  # Flip parents into chronological order
  return(Parents[order(length(Parents):1)])
   
}
  
  