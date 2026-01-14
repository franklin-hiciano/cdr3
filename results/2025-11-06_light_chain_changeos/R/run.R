library(tidyverse)

CHANGEO_DIR <- ("/sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/")
changeo_IGK <- read.csv(paste0(CHANGEO_DIR, "IGK", "/", "master_changeo_unmutated_500_seqs_filtered_productive.tsv"), sep='\t')
changeo_IGL <- read.csv(paste0(CHANGEO_DIR, "IGL", "/", "master_changeo_unmutated_500_seqs_filtered_productive.tsv"), sep='\t')
OUT_DIR <- "/sc/arion/scratch/hiciaf01/projects/cdr3/results/clone_counts_all"
dir.create(OUT_DIR, recursive = TRUE, showWarnings = FALSE)

count_clones <- function() {
  for (locus in c("IGK","IGL")) {
    for (functional in c("productive", "unproductive")) {
      for (SHM_status in c("mutated", "unmutated")) {
        changeo <- read.table(file.path(CHANGEO_DIR, locus, paste0("master_changeo_", SHM_status, "_500_seqs_filtered_", functional, ".tsv")), sep = "\t", header = TRUE, stringsAsFactors = FALSE, quote = "", comment.char = "")
        clone_counts <- changeo %>% group_by(.data[["sample_id"]]) %>% summarize(unique_clones = n_distinct(clone_id))
        write.table(clone_counts, file = file.path(OUT_DIR, paste0("clone_counts_", locus, "_", SHM_status, "_", functional, ".tsv")), sep = "\t", quote = FALSE, row.names = FALSE)
      }
    }
  }
}

count_clones()

#TEST THE ABOVE WORKS TO LEAVE IT OVERNIGHT


CHANGEO_DIR <- "/sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/"
OUT_DIR <- "/sc/arion/scratch/hiciaf01/projects/cdr3/results/clone_counts_test"  # set to wherever you want
dir.create(OUT_DIR, recursive = TRUE, showWarnings = FALSE)

# already loaded:
# changeo_IGK, changeo_IGL

# 1) quick, in-memory test: compute counts for the one combo you loaded
test_igk <- changeo_IGK %>%
  group_by(sample_id) %>%
  summarize(unique_clones = n_distinct(clone_id), .groups = "drop")

test_igl <- changeo_IGL %>%
  group_by(sample_id) %>%
  summarize(unique_clones = n_distinct(clone_id), .groups = "drop")

# sanity checks
stopifnot(all(test_igk$unique_clones >= 0), all(test_igl$unique_clones >= 0))
print(head(test_igk))
print(head(test_igl))

# 2) test the write step: write exactly the two outputs you expect for this combo
write.table(
  test_igk,
  file = file.path(OUT_DIR, "clone_counts_IGK_unmutated_productive.tsv"),
  sep = "\t", quote = FALSE, row.names = FALSE
)

write.table(
  test_igl,
  file = file.path(OUT_DIR, "clone_counts_IGL_unmutated_productive.tsv"),
  sep = "\t", quote = FALSE, row.names = FALSE
)

# 3) verify round-trip (read back) before running overnight
check_igk <- read.table(file.path(OUT_DIR, "clone_counts_IGK_unmutated_productive.tsv"),
                        sep = "\t", header = TRUE)
check_igl <- read.table(file.path(OUT_DIR, "clone_counts_IGL_unmutated_productive.tsv"),
                        sep = "\t", header = TRUE)

stopifnot(nrow(check_igk) == nrow(test_igk), nrow(check_igl) == nrow(test_igl))


## END TEST





plot_clones <- function() {

  for (locus in list(changeo_IGK, changeo_IGL)) {
    for changeo
    
    clone_counts <- changeo %>% group_by(.data[["sample_id"]]) %>% summarize(unique_clones = n_distinct(sequence))
    
    
    p <- ggplot(clone_counts, aes(x="", y=unique_clones)) +
      geom_boxplot(outlier.shape=NA) + 
      labs(title = paste0("Clone counts for ", changeo$locus[[1]], "")) +
      geom_jitter(width=0.1, size = 2) +
      theme_minimal() +
      labs(x="Samples", y="Number of unique clones")
    print(p)
  }
}



changeo_IGL_mutated <- read.csv(paste0(CHANGEO_DIR, "IGL", "/", "master_changeo_mutated_500_seqs_filtered_productive.tsv"), sep='\t')
length(unique(changeo_IGL_mutated$sequence_aa))


#testing
plot_clones()
clone_counts <- changeo_IGL %>% group_by(.data[["sample_id"]]) %>% summarize(unique_clones = n_distinct(sequence))
