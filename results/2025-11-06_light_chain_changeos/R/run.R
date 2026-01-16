library(tidyverse)
library(stringr)
library(patchwork)

RESULTS <- "/sc/arion/work/hiciaf01/projects/cdr3/results/2025-11-06_light_chain_changeos/"
DATA <- "/sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/"

#REQUIRED FUNCTIONS: count_clones in run.sh
plot_clones <- function() {
  plots <- list()
  for (locus in c("IGK", "IGL")) {
    for (SHM_status in c("mutated", "unmutated")) {
      for (functional in c("productive", "unproductive")) {
        clone_counts <- read.table(file.path(RESULTS, paste0("/R/count_clones/clone_counts_", locus, "_", SHM_status, "_", functional, ".tsv")), sep = "\t", header = TRUE, stringsAsFactors = FALSE, quote = "", comment.char = "")
        p <- ggplot(clone_counts, aes(x="", y=unique_clones)) +
          geom_boxplot(outlier.shape=NA) + 
          labs(title=paste0("Clone counts for ", locus), subtitle=paste0(str_to_title(SHM_status), ", ", functional, " clones"), caption=paste0("n = ", nrow(clone_counts), ", mean = ", round(mean(clone_counts$unique_clones)))) +
          geom_jitter(width=0.1, size = 2) +
          theme_minimal() +
          labs(x="Samples", y="Number of unique clones")
        plots[[length(plots) + 1]] <- p
      }
    }
  }
  wrap_plots(plots, ncol=4, nrow=2) +
    plot_layout(axes="collect")
}
plot_clones()

#REQUIRED FUNCTIONS: sum_clones in run.sh
plot_summed_clone_counts <- function() {
  for (locus in c("IGK", "IGL")) {
    clone_counts <- read.table(file.path(RESULTS, paste0("/R/count_clones/summed_clone_counts_", locus, ".tsv")), sep = "\t", header = TRUE, stringsAsFactors = FALSE, quote = "", comment.char = "")
    p <- ggplot(clone_counts, aes(x="", y=unique_clones)) +
      geom_boxplot(outlier.shape=NA) + 
      labs(title=paste0("Clone counts for ", locus), caption=paste0("n = ", nrow(clone_counts), ", mean = ", round(mean(clone_counts$unique_clones)))) +
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

plot_all_sequence_counts <- function() {
  all_counts <- data.frame()  
  for (locus in c("IGK", "IGL")) {
    for (SHM_status in c("mutated", "unmutated")) {
      for (functional in c("productive", "unproductive")) {
        file <- read.table(file.path(RESULTS, paste0("R/count_all_clones/clone_counts_", locus, "_", SHM_status, "_", functional, ".tsv")), sep = "\t", header = TRUE, stringsAsFactors = FALSE, quote = "", comment.char = "")
        v <- as.numeric(unlist(file))
        all_counts <- rbind(all_counts, data.frame(
          name = paste(str_to_title(SHM_status), functional),
          count = v[!is.na(v)][1]
        ))
      }
    }
    
    png(
      filename = file.path(RESULTS, paste0("R/plots/count_all_clones/plot_all_sequence_counts_", locus, ".png")),
      width = dev.size("in")[1], height = dev.size("in")[2], units = "in",
      res=300
    )
    p <- ggplot(all_counts, aes(x=name, y=count, fill = name)) +
      geom_col() + 
      labs(title=paste0("Number of B cells in ", locus, " changeo files"), caption=paste0(prettyNum(sum(all_counts$count), big.mark = ",", scientific = FALSE), " total cells")) +
      theme_minimal() +
      theme(legend.position = "none") +
      labs(x="Files", y="Number of B cells", fill = "") +
      scale_y_continuous("trans"="log10")
    print(p)
  }
}
plot_all_sequence_counts()
