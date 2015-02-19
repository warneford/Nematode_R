# Extract info files for RW10890 movies
RW10890Auxfiles <- list.files("Raw_data", pattern="^.+RW10890.+AuxInfo.csv$")
RW10890Auxfiles.path <- paste0("Raw_data/", RW10890Auxfiles)
AuxRW10890 <- do.call("rbind", lapply(RW10890Auxfiles.path, read.csv, header=TRUE))
AuxRW10890 <- data.frame(lapply(AuxRW10890, as.character), stringsAsFactors=FALSE)
AuxRW10890$name <- gsub("pal-1", "pal.1", AuxRW10890$name)
AuxRW10890$name
?gsub
# Sort by axis
AuxRW10890 <- AuxRW10890[order(AuxRW10890$axis, na.last = TRUE, decreasing = TRUE),]
