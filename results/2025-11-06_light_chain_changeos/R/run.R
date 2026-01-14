library(tidyverse)

RESULTS <- "/sc/arion/work/hiciaf01/projects/cdr3/results/2025-11-06_light_chain_changeos/"

plot_clones <- function() {
  for (locus in c("IGK", "IGL")) {
    for (SHM_status in c("mutated", "unmutated")) {
      for (functional in c("productive", "unproductive")) {
        clone_counts <- read.table(file.path(RESULTS, paste0("/R/count_clones/clone_counts_", locus, "_", SHM_status, "_", functional, ".tsv")), sep = "\t", header = TRUE, stringsAsFactors = FALSE, quote = "", comment.char = "")
        p <- ggplot(clone_counts, aes(x="Samples", y=unique_clones)) +
          geom_boxplot(outlier.shape=NA) + 
          labs(title="Boxplot counting distinct clones for each sample in the dataset", subtitle=paste0(SHM_status, ", ", functional, " ", locus, " clones")) +
          geom_jitter(width=0.1, size = 2) +
          theme_minimal() +
          labs(x="Samples", y="Number of unique clones")
        print(p)
      }
    }
  }
}
plot_clones()

plot_summed_clone_counts <- function() {
  for (locus in c("IGK", "IGL")) {
    clone_counts <- read.table(file.path(RESULTS, paste0("/R/count_clones/summed_clone_counts_", locus, ".tsv")), sep = "\t", header = TRUE, stringsAsFactors = FALSE, quote = "", comment.char = "")
    p <- ggplot(clone_counts, aes(x="", y=unique_clones)) +
      geom_boxplot(outlier.shape=NA) + 
      labs(title=paste0("Clone counts for ", locus), caption="Mutated, unmutated, productive, and unproductive") +
      geom_jitter(width=0.1, size = 2) +
      theme_minimal() +
      labs(x="Samples", y="Number of unique clones")
    print(p)
  }
}

plot_summed_clone_counts()


get_means_of_clone_counts <- function() {
  means <- c()
  for (locus in c("IGK", "IGL")) {
    clone_counts <- read.table(file.path(RESULTS, paste0("/R/count_clones/summed_clone_counts_", locus, ".tsv")), sep = "\t", header = TRUE, stringsAsFactors = FALSE, quote = "", comment.char = "")
    means <- c(means, mean(clone_counts$unique_clones))
  }
  clone_count_means <- data.frame(
    Locus = c("IGK", "IGL"),
    Mean = means
  )
  write.table(clone_count_means, file.path(RESULTS, "R/count_clones/", "summed_clone_count_means.tsv"), sep = "\t", quote = FALSE, row.names = FALSE)
}

get_means_of_clone_counts()
