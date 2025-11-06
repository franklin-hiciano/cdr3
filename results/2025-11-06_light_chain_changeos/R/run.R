library(readr)
library(dplyr)
library(ggplot2)

base_dir <- "/sc/arion/work/hiciaf01/projects/cdr3/results/2025-11-06_light_chain_changeos"

plot_number_of_clones_per_sample <- function() {
  clone_counts_list <- list() 
  for (chain in c("IGK", "IGL")) {
    file_path <- paste0(base_dir, "/", chain, ".tsv") 
    changeo_data <- read_tsv(file_path, show_col_types = FALSE)
    clone_counts <- changeo_data %>%
      group_by(sample_id) %>% # Assuming a 'sample_id' column exists
      summarise(
        num_clones = n_distinct(clone_id),
        chain = chain # Add the chain type for plotting
      )
    clone_counts_list[[chain]] <- clone_counts
  }
  
  final_data <- bind_rows(clone_counts_list)
  p <- ggplot(final_data, aes(x = chain, y = num_clones)) +
    geom_boxplot() +
    labs(
      title = "Number of Unique Clones per Sample (IGK vs IGL)",
      x = "Immunoglobulin Chain",
      y = "Number of Unique Clones"
    ) +
    theme_minimal()
  
  print(p)
  
  # Optional: Print summary statistics to check against expectation
  print(final_data %>% group_by(chain) %>% summarise(average_clones = mean(num_clones)))
}

# Execute the function
# plot_number_of_clones_per_sample(base_dir)