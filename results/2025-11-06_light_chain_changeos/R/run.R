library(tidyverse)
library(stringr)
library(patchwork)

RESULTS <- "/sc/arion/work/hiciaf01/projects/cdr3/results/2025-11-06_light_chain_changeos/"
DATA <- "/sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/"

#REQUIRED FUNCTIONS: count_clones in run.sh
plot_distinct_clones <- function() {
  for (locus in c("IGK", "IGL")) {
    plots <- list()
    for (SHM_status in c("mutated", "unmutated")) {
      for (functional in c("productive", "unproductive")) {
        clone_counts <- read.table(
          file.path(RESULTS, paste0("/R/count_clones/clone_counts_", locus, "_", SHM_status, "_", functional, ".tsv")),
          sep="\t", header=TRUE, stringsAsFactors=FALSE, quote="", comment.char=""
        )
        label <- paste(str_to_title(SHM_status), functional)
        clone_counts$label <- label
        p <- ggplot(clone_counts, aes(x = label, y = unique_clones)) +
          geom_boxplot(outlier.shape=NA) +
          geom_violin(alpha)
          geom_jitter(width=0.1, size=2) +
          theme_minimal() +
          labs(title=NULL, subtitle=NULL, caption=NULL, x="Samples", y="Number of unique clones")
        
        plots[[length(plots) + 1]] <- p
      }
    }
    png(filename = file.path(RESULTS, paste0("R/plots/count_clones/plot_distinct_clones_", locus, ".png")), width = dev.size("in")[1], height = dev.size("in")[2], units = "in", res=300)
    print(
      wrap_plots(plots, ncol=4, nrow=1) +
        plot_annotation(title = paste0("Clone counts for ", locus)) +
        plot_layout(axes="collect")
    )
    dev.off()
  }
}
plot_distinct_clones()

specie <- c(rep("sorgho" , 3) , rep("poacee" , 3) , rep("banana" , 3) , rep("triticum" , 3) )
condition <- rep(c("normal" , "stress" , "Nitrogen") , 4)
value <- abs(rnorm(12 , 0 , 15))
data <- data.frame(specie,condition,value)

plot_clones()

get_files_info
make_clone_count_metadata <- function() {
  metadata <- data.frame()
  for (locus in c("IGK", "IGL")) {
    for (SHM_status in c("mutated", "unmutated")) {
      for (functional in c("productive", "unproductive")) {
        clone_counts <- read.table(file.path(RESULTS, paste0("/R/count_clones/clone_counts_", locus, "_", SHM_status, "_", functional, ".tsv")), sep = "\t", header = TRUE, stringsAsFactors = FALSE, quote = "", comment.char = "")
        metadata <- rbind(metadata, data.frame(
          locus = locus,
          SHM_status = SHM_status,
          functional = functional,
          n_samples = nrow(clone_counts),
          mean_unique_clones = mean(clone_counts$unique_clones),
          rounded_mean_unique_clones = round(mean(clone_counts$unique_clones)),
          sum_unique_clones = sum(clone_counts$unique_clones),
          stringsAsFactors = FALSE
        ))
      }
    }
  }
  write.table(metadata, file.path(RESULTS, "R/count_clones/", "clone_count_metadata.tsv"), sep = "\t", quote = FALSE, row.names = FALSE)
}
make_clone_count_metadata()

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
  for (locus in c("IGK", "IGL")) {
    all_counts <- data.frame()
    for (SHM_status in c("mutated", "unmutated")) {
      for (functional in c("productive", "unproductive")) {
        file <- read.table(file.path(RESULTS, paste0("R/count_clones/clone_counts_", locus, "_", SHM_status, "_", functional, ".tsv")), sep = "\t", header = TRUE, stringsAsFactors = FALSE, quote = "", comment.char = "")
        v <- as.numeric(unlist(file))
        print(file$sample_id)
        
        all_counts <- rbind(all_counts, data.frame(
          file = rep(paste(SHM_status, functional), times=length(ncol(file))),
          sample_id = unlist(file$sample_id),
          unique_clones = file$unique_clones
        ))
      }
    }
    all_counts_unsorted <- all_counts %>%
      group_by(sample_id) %>%
      mutate(total_clones = sum(unique_clones)) %>%
      ungroup() %>%
      mutate(sample_id = factor(sample_id, levels = unique(all_counts$sample_id)))
    
    p <- ggplot(all_counts_unsorted, aes(fill=file, y=unique_clones, x=sample_id)) + 
      geom_bar(position="stack", stat="identity") +
      theme_minimal() +
      theme(legend.position = "top", legend.justification = "right",
            axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 6)) +
      labs(title = paste0("Number of unique clones per ", locus, " sample"), x="Sample", y="Number of unique clones")
    print(p)
    ggsave(filename = file.path(RESULTS, paste0("R/plots/plot_all_sequence_counts/plot_distinct_clones_", locus, "_stacked_plot_unsorted", ".png")), 
           plot = p, 
           width = dev.size("in")[1], 
           height = dev.size("in")[2], 
           units = "in", 
           dpi = 600)
    
    
    all_counts_sorted <- all_counts %>%
      group_by(sample_id) %>%
      mutate(total_clones = sum(unique_clones)) %>%
      ungroup() %>%
      arrange(total_clones) %>%
      mutate(sample_id = factor(sample_id, levels = unique(sample_id)))
    
    p <- ggplot(all_counts_sorted, aes(fill=file, y=unique_clones, x=sample_id)) + 
      geom_bar(position="stack", stat="identity") +
      theme_minimal() +
      theme(legend.position = "top", legend.justification = "right",
            axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 6)) +
      labs(title = paste0("Number of unique clones per ", locus, " sample"), x="Sample", y="Number of unique clones")
    print(p)
    ggsave(filename = file.path(RESULTS, paste0("R/plots/plot_all_sequence_counts/plot_distinct_clones_", locus, "_stacked_plot_sorted", ".png")), 
           plot = p, 
           width = dev.size("in")[1], 
           height = dev.size("in")[2], 
           units = "in", 
           dpi = 600)
    
  }
  
}
plot_all_sequence_counts()
