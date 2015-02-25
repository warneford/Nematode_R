GetParent <- function(x){
  if(is.na(x)) return(NA)
  if(x=="AB" || x=="P1") return("P0")
  
  if(x=="EMS" || x=="P2") return("P1")
  if(x=="E" || x=="MS") return("EMS")
  if(x=="C" || x=="P3") return("P2")
  if(x=="D" || x=="P4") return("P3")
  if(x=="Z2" || x=="Z3") return("P4")
  if(is.element(substr(x,nchar(x),nchar(x)),c("a","p","d","v","l","r"))) return (substr(x,1,nchar(x)-1))
  
  return(NA)
  
}