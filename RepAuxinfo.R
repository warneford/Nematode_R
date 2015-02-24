# Extracts and aggregates AuxInfo.csv files for desired reporter lineage from folder named "Raw_data"
RepAuxfiles <- function(Lineage) {
foo <- paste0("^.+", Lineage, ".+AuxInfo.csv$")

RepAuxfiles <- list.files("Raw_data", pattern=foo)
RepAuxfiles.path <- paste0("Raw_data/", RepAuxfiles)
RepAux <- do.call("rbind", lapply(RepAuxfiles.path, read.csv, header=TRUE))
RepAux <- data.frame(lapply(RepAux, as.character), stringsAsFactors=FALSE)

# Change "-" to "." in reporter name for indexing
RepAux$name <- gsub("pal-1", "pal.1", RepAux$name)

# Sort by axis
RepAux <- RepAux[order(RepAux$axis, na.last = TRUE, decreasing = TRUE),]}