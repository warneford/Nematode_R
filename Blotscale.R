# Compares cell averaged embryo blot data against arbitrary reference
# embryo and generates scaling factor scales blot data to reference embryo
Blotscale <- function(AverageDF) {
    df <- data.frame(Embryo = names(AverageDF)[-c(1)])

    for (i in 1:length(df$Embryo))  
    { temp.norm <-lm(AverageDF[[i+1]] ~ AverageDF[[2]])
      df$slope[[i]] <- coef(temp.norm)[2] }

return(df)}



