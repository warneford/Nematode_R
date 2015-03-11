# Optimize correction factor for z plane, argument is list of raw SCD data frames

OptimZ <- function(listdf) {

  
  CorrectionFactors=c(0:200/1000)
meanRs=c()

for(i in CorrectionFactors){ 
  NormZblot <-  cbind(listdf[[1]][,c(1,2)], as.data.frame(lapply(listdf, function(df) {
  Znorm <- (33-df$zraw)*i + 1
  df$blot*Znorm})))
  TheseCors <- cor(NormZblot[-c(1,2)], use="pairwise.complete.obs")
  meanRs=c(meanRs,mean(TheseCors[row(TheseCors)!=col(TheseCors)]))       
}



# Return optimal correction factor
OptimCor <- CorrectionFactors[which.max(meanRs)]
plot(CorrectionFactors,meanRs,xaxp = c(min(CorrectionFactors), max(CorrectionFactors), 100),
     main = "Correction factors versus Blot Covariance")
abline(v=OptimCor,col="red")
text(x = 0.13, y = 0.8, paste0("Optimal Z correction factor is ", OptimCor))

return(OptimCor)}