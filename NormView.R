# Plot Mean versus SD of blot data to assess success of normalization method
# dataname specifies name of dataset being analyzed
NormView <- function(listdf, dataname) {

  # Create axis labels
  EmbOrRL <- c("R", "L")
  EmbOrRLB <- c(EmbOrRL, "Both")


df <-  listdf$AverageCellblot1
df2 <- listdf$AverageCellblot2


pdf(onefile = TRUE, file = paste0(dataname, " Normalization.pdf"))


# Plot Z-only normalized data
lapply(EmbOrRLB, function(Or) {

  templm <- lm(df[[Or]]$SD ~ df[[Or]]$Mean)
plot(x = df[[Or]]$Mean, y = df[[Or]]$SD, 
     main = paste0("Z normalized (", Or, " Orientation) Mean versus SD"),
     xlab = "Cell Mean Expression", ylab = "Cell Standard Dev")
text(x = 500,y = 0.5*max(df[[Or]]$SD, na.rm = TRUE), paste0("Slope is ", format(coef(templm)[2], digits = 4)))
abline(templm, col = "red")
    

# Plot Z- and raw blot intensity normalized data

  templm2 <- lm(df2[[Or]]$SD ~ df2[[Or]]$Mean)
  plot(x = df2[[Or]]$Mean, y = df2[[Or]]$SD, 
       main = paste0("Z & blot normalized (", Or, " Orientation) Mean versus SD"),
       xlab = "Cell Mean Expression", ylab = "Cell Standard Dev")
  abline(templm2, col = "red")
  text(x = 500,y = 0.5*max(df[[Or]]$SD, na.rm = TRUE), paste0("Slope is ", format(coef(templm2)[2], digits = 4))) 
})

dev.off()

}


