# Extracts and aggregates AuxInfo.csv files for desired reporter lineage from folder named "Raw_data"
RepAuxfiles <- function(Lineage, dir = Rawdir) {
foo <- paste0(".+AuxInfo.csv$")

RepAuxfiles <- list.files(dir, pattern=foo)
RepAuxfiles.path <- paste0(dir, "/", RepAuxfiles)
RepAux <- do.call("rbind", lapply(RepAuxfiles.path, read.csv, header=TRUE))
RepAux <- data.frame(lapply(RepAux, as.character), stringsAsFactors=FALSE)

# Change "-" to "." in reporter name for indexing

<<<<<<< HEAD
RepAux$name <- gsub("(\\D{3})(-)(\\d)", "\\1.\\3", RepAux$name, perl = TRUE)
=======
RepAux$name <- gsub("(\\D{3})(.)(\\d)", "\\1.\\3", RepAux$name, perl = TRUE)
>>>>>>> 1a28e9e5896efa283f2d81dc1cc3ce56e69a7f87

# Sort by axis
RepAux <- RepAux[order(RepAux$axis, na.last = TRUE, decreasing = TRUE),]}