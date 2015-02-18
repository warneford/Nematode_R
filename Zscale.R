# Optimize correction factor for z plane

CorrectionFactors=c(0:200/1000)
meanRs=c()
for(i in CorrectionFactors){ 
  PalData[["NormalizedZ_blot"]] <-  cbind(PalData[["SCD_Data"]][[1]][,c(1,2)], as.data.frame(lapply(PalData[["SCD_Data"]], function(df) {
  Znorm <- (33-df$zraw)*i + 1
  df$blot*Znorm})))
  TheseCors <- cor(PalData[["NormalizedZ_blot"]][-c(1,2)], use="pairwise.complete.obs")
  meanRs=c(meanRs,mean(TheseCors[row(TheseCors)!=col(TheseCors)]))       
}
plot(CorrectionFactors,meanRs,xaxp = c(min(CorrectionFactors), max(CorrectionFactors), 100))
abline(v=ZCOR,col="red")

# Return optimal correction factor
OptimCor <- CorrectionFactors[which.max(meanRs)]