library(tidyverse)

plot_clones <- function() {
  for (locus in c("IGK", "IGL")) {
    for (SHM_status in c("mutated", "unmutated")) {
      for (functional in c("productive", "unproductive")) {
        clone_counts <- read.table(file.path(paste0("/sc/arion/work/hiciaf01/projects/cdr3/results/2025-11-06_light_chain_changeos/R/count_clones/clone_counts_", locus, "_", SHM_status, "_", functional, ".tsv")), sep = "\t", header = TRUE, stringsAsFactors = FALSE, quote = "", comment.char = "")
        p <- ggplot(clone_counts, aes(x="Samples", y=unique_clones)) +
          geom_boxplot(outlier.shape=NA) + 
          labs(title="Boxplot counting distinct clones for each sample in the dataset", subtitle=paste0(SHM_status, ", ", functional, " ", locus, " clones"))
        geom_jitter(width=0.1, size = 2) +
          theme_minimal() +
          labs(x="Samples", y="Number of unique clones")
        print(p)
      }
    }
  }
}
plot_clones()
