# plot regular blot values
library(ggplot2)
plot1 <- 
  ggplot(PalData[["SCDblot_cutoff"]], aes(x=Mean, y=Std_dev)) +
  geom_point() +
  geom_smooth(method=lm, colour="red") +
  geom_text(aes(x = median(PalData$SCDblot_cutoff$Mean, na.rm = TRUE), y = max(PalData$SCDblot_cutoff$Std_dev, na.rm = TRUE)*0.9, label = paste("R^2 is ", format(summary(lm.reg)$adj.r.squared, digits=4)))) +
  ggtitle("Mean Pal-1 Blot Values versus Standard Deviation") 

# plot gweight only normalized data (Method 1)
plot2 <- 
  ggplot(PalData[["SCDblot_cutoff"]], aes(x=Normalized1_Mean, y=Normalized1_Std_dev)) +
  geom_point() +
  geom_smooth(method=lm, colour="red") +
  geom_text(aes(x = median(PalData$SCDblot_cutoff$Normalized1_Mean, na.rm = TRUE), y = max(PalData$SCDblot_cutoff$Normalized1_Std_dev, na.rm = TRUE)*0.9, label = paste("R^2 is ", format(summary(lm.norm1)$adj.r.squared, digits=4)))) +
  ggtitle("Standard Deviation versus Gweight Normalized Mean Blot Values")

# plot Z normalized data (Method 1)
plotZ <- 
  ggplot(PalData[["SCDblot_cutoff"]], aes(x=NormalizedZ_Mean, y=NormalizedZ_Std_dev)) +
  geom_point() +
  geom_smooth(method=lm, colour="red") +
  geom_text(aes(x = median(PalData$SCDblot_cutoff$NormalizedZ_Mean, na.rm = TRUE), y = max(PalData$SCDblot_cutoff$NormalizedZ_Std_dev, na.rm = TRUE)*0.9, label = paste("R^2 is ", format(summary(lm.normZ)$adj.r.squared, digits=4)))) +
  ggtitle("Standard Deviation versus Mean Z-Normalized Pal-1 Blot Values")
# plot R normalized data
plotR <- 
  ggplot(PalData[["SCDblot_cutoff"]], aes(x=NormalizedR_Mean, y=NormalizedR_Std_dev)) +
  geom_point() +
  geom_smooth(method=lm, colour="red") +
  geom_text(aes(x = median(PalData$SCDblot_cutoff$NormalizedR_Mean, na.rm = TRUE), y = max(PalData$SCDblot_cutoff$NormalizedR_Std_dev, na.rm = TRUE)*0.9, label = paste("R^2 is ", format(summary(lm.normR)$adj.r.squared, digits=4)))) +
  ggtitle("Standard Deviation versus Mean R-Normalized Pal-1 Blot Values")

# plot L normalized data
plotL <- 
  ggplot(PalData[["SCDblot_cutoff"]], aes(x=NormalizedL_Mean, y=NormalizedL_Std_dev)) +
  geom_point() +
  geom_smooth(method=lm, colour="red") +
  geom_text(aes(x = median(PalData$SCDblot_cutoff$NormalizedL_Mean, na.rm = TRUE), y = max(PalData$SCDblot_cutoff$NormalizedL_Std_dev, na.rm = TRUE)*0.9, label = paste("R^2 is ", format(summary(lm.normL)$adj.r.squared, digits=4)))) +
  ggtitle("Standard Deviation versus Mean L-Normalized Pal-1 Blot Values")