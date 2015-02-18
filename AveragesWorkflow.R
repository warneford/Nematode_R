# Script to Import Cell Average data for RW10890 embryos

files <- list.files(pattern="SCA")

# Construct list of SCA data files

AverageData=list()
AverageData <- lapply(files, read.csv)
names(AverageData) <- gsub(".csv","", files)

# Specify columns to remove from data
drops <- c("cellTime")
AverageData <- lapply (AverageData, function(x) {x[,!(names(x) %in% drops)]})

# Create Empty Data Frame of Cells
Celldf <- data.frame(Cell=AverageData[[1]]["cell"], Mean=c(rep(0,nrow(SCD_Data[[1]]))), Variance=c(rep(0,length(nrow(SCD_Data[[1]]))))

# Find missing values and assign NA (where no x and y coordinates given)
  AverageData <- lapply(AverageData, function(df) {within(df, blot[x==0 & y==0] <- NA)
})

# Assemble all blot data
blotdata <- cbind(Celldf[[1]], as.data.frame(lapply(AverageData, function(x) {x$blot})))

# Compute statistics for each cell
Celldf[, 2] <- apply(blotdata[-c(1)], 1, function(x) {mean(x, na.rm=TRUE)})
Celldf[, 3] <- apply(blotdata[-c(1)], 1, function(x) {var(x, na.rm=TRUE)})
