# Plots lineages from list of cells
# Redundant is a logical operator that when false removes cells that are parents of other cells in list, 
# leaving only unique lineages. 
PlotList <- function(list, df, sdf, name = NA, Redundant = FALSE) {
  if (is.na(name) == TRUE) {stop("Specify output filename in format \"xxxx.pdf\"")}

    foo <- as.character(list)
    
            if (Redundant == FALSE) {
              # remove cell names with duplicate lineages
              for (i in 1:length(foo))
              {TempParent <- GetParents(foo[i])
               foo <- foo[! (foo %in% TempParent)]}
            }

    pdf(onefile = TRUE, file = name)
    for (i in 1:length(foo))
    {Plotcell(foo[i], df = df, sdf = sdf, ancestors = TRUE)}
    dev.off()
    
    return(name)}

