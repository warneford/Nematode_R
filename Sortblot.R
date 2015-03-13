# Function that subsets averaged blot data for certain parameter ranges (Mean, CV, Time)
# Argument CVchangeParPar subsets cells  with CV values that differ from their parent by
# factor greater than that specified by CVchangePar
# eg. CVchangePar = 2 will find cells with CV values that are over double that of their parents
# eg. CVchangePar = 0.1 will find cells with CV values that less than 0.1x that of their parents
# CVchangeDt is equivalent to CVchangePar for daughter cells
# Output DaughterCVRatio is the value of the cell CV over the daughter CV

Sortblot <-function(df, CVchangePar = NA, CVchangeDt = NA, 
                    LoMean = 0, HiMean = Inf, LoCV = 0, 
                    HiCV = Inf, TimeMax = Inf,
                    outnames = FALSE) {
  
  # Source functions
  source("Functions.R")
  
  # Subset cells
  tempdf <- subset(df, (Mean > LoMean) & (Mean < HiMean) & (Time < TimeMax))
  outdf <- subset(tempdf,  (CV > LoCV) & (CV < HiCV))
  
  
  # Subset cells that match CVchangePar argument
  if (is.na(CVchangePar) == FALSE) {
    
    Outcells <- c()
    OutParents <- c()
    if (CVchangePar < 0) {stop("Enter positive value for CVchangePar")}
    
    # Compute CV of Parent cells from subsetted list
    
    outdf <- cbind(outdf[,c(1:5)], ParentCV = rep(NA, nrow(outdf)), CV = outdf$CV)
    
    CellList <- as.character(outdf$ID)
    
    for ( i in 1:length(CellList)) {
      
      CellCV <- df$CV[df$ID == CellList[i]] 
      Parent <- GetParent(CellList[i])
      ParCV <- df$CV[df$ID == Parent]
      
      
      if(any(is.na(c(CellCV, Parent, ParCV)))) {next}
      if(any(c(CellCV, ParCV) < 0)) {next}
      # Generate list of Cells that match CVchangePar criteria
      # For CVchangePar > 1, output cells with lower CVs than their parents
      
      
      if (CVchangePar >= 1) { 
        if(CellCV > ParCV*CVchangePar) {Outcells <- c(Outcells, CellList[i])
                                        # List Parent cell CV                               
                                        outdf$ParentCV[outdf$ID == CellList[i]] <- ParCV
                                        OutParents <- c(OutParents, Parent)} 
        else {next}
      }
      # For CVchangePar < 1, output cells with lower CVs than their parents
      else { 
        if(CellCV < ParCV*CVchangePar)  {Outcells <- c(Outcells, CellList[i])
                                         # List Parent cell CV                              
                                         outdf$ParentCV[outdf$ID == CellList[i]] <- ParCV
                                         OutParents <- c(OutParents, Parent)}
        else {next}                            
      }  
    }
    
    # Subset data.frames for matching cells
    Parentdf <- Selectcell(Cell_names = OutParents, blotdf = df, Chronological = FALSE)
    outdf <- Selectcell(Cell_names = Outcells, blotdf = outdf, Chronological = FALSE)
    
    outdf$Comment <- rep(NA, nrow(outdf))
    if (length(Outcells) == 0) {stop("No cells match the specified criteria for parent cells")}
  }
  
  # To subset daughter cell CV changes
  if (is.na(CVchangeDt) == FALSE) {
    
    Outcells <- c()
    DaughterMatch <- c()
    
    
    
    if (CVchangeDt < 0) {stop("Enter positive value for CVchangeDt")}
    
    # Compute CV of Daughter cells from subsetted list
    
    
    
    outdf$Daughter1CV <- rep(NA, nrow(outdf))
    outdf$Daughter2CV <- rep(NA, nrow(outdf))
    
    CellList <- as.character(outdf$ID)
    for ( i in 1:length(CellList)) {
      
      CellCV <- df$CV[df$ID == CellList[i]] 
      
      # Obtain two immediate daughter cell names
      Daughters <- GetDaughters(Cell = CellList[i],Immediate = TRUE)
      
      
      DtCV <- df$CV[df$ID %in% Daughters]
      if(any(is.na(c(CellCV, Daughters, DtCV)))) {next}
      if(any(c(CellCV, DtCV) < 0)) {next}
      
      
      # Generate list of Cells that match CVchangeDt criteria
      
      
      # For CVchangeDt > 1, output cells with lower CVs than their daughters
      if (CVchangeDt >= 1) { 
        if(any(DtCV > CellCV*CVchangeDt)) {
          # List Daughter cell CV                               
          outdf$Daughter1CV[outdf$ID == CellList[i]] <- DtCV[1]
          outdf$Daughter2CV[outdf$ID == CellList[i]] <- DtCV[2]
          
          # Append matching cell to list, along with daughter cells
          Outcells <- c(Outcells, CellList[i])
          # Append matching daughters to list
          DaughterMatch <- c(DaughterMatch, Daughters)
          
        } 
        
      }
      # For CVchangeDt < 1, output cells with lower CVs than their parents
      else { 
        if(any(DtCV < CellCV*CVchangeDt)) {
          
          # Ratio of daughter Cell CV to Cell CV                          
          outdf$Daughter1CV[outdf$ID == CellList[i]] <- DtCV[1]
          outdf$Daughter2CV[outdf$ID == CellList[i]] <- DtCV[2]
          
          # Append matching cell to list
          Outcells <- c(Outcells, CellList[i])
          # Append matching daughters to list
          DaughterMatch <- c(DaughterMatch, Daughters)
          
        }} 
      
      # End of loop
    }
    if (length(Outcells) == 0) {stop("No cells match the specified criteria for daughter cells")}
    # Subset matching cells 
    outdf <- Selectcell(Cell_names = Outcells, blotdf = outdf,Chronological = FALSE)
    
    outdf$Comment <- rep(NA, nrow(outdf))
    
    # Subset matching daughter cells
    Daudf <- Selectcell(Cell_names = DaughterMatch, blotdf = df, Chronological = FALSE)
    
    
    # Append empty columns to daughter data.frame to match outdf for concatentation
    foo <- names(outdf)[!(names(outdf) %in% names(Daudf))]
    Daudf <- cbind(Daudf, vapply(foo, function(x) {rep(NA, nrow(Daudf))}, 
                                 1:nrow(Daudf), USE.NAMES = TRUE))
    
    Daudf$Comment <- rep("Daughter", nrow(Daudf))
    
    
    
    # Group cells next to their daughters in data.frame
    CellOrder <- seq(from = 1,to = nrow(outdf)*3,by = 3)  
    c <- c(CellOrder, CellOrder)
    c <- c[order(c)]
    DtOrder <- c + c(1,2)
    outdf$Order <- CellOrder
    Daudf$Order <- DtOrder
    
    # Combine Cell and Daughter data
    outdf <- rbind(outdf, Daudf)
    
    # Group cells by "family"
    outdf <- outdf[order(outdf$Order),]
    outdf <- outdf[,!(names(outdf) %in% "Order")]
    
    outdf <- cbind(outdf[,!(names(outdf) %in% "Comment")], Comment =outdf$Comment)
    
  }
  if (outnames == TRUE) {return (as.character(outdf$ID))}
  return(outdf)}