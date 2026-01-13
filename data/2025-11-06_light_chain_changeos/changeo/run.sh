#!/bin/bash
set -e -x
set -euo pipefail
DATA="/sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/"
RESULTS="/sc/arion/work/hiciaf01/projects/cdr3/results/2025-11-06_light_chain_changeos/"

function download_changeo {
	# 1. Download the entire folder from here https://drive.google.com/drive/u/0/folders/1WP4QZIXSbrtX92BKsgTOhnHXSKiqyz4z
        # 2. Zip up everything into ChangeO_prod_unprod.zip
	# 3. scp it into /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo
	# 4. Also download /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/ because that didn't come for some reason
	:
}

function unzip_changeo {
	unzip /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/ChangeO_prod_unprod.zip -d /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/
}

function unzip_remaining_folders {
	unzip /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/ChangeO_prod_unprod-20260109T180954Z-3-002.zip -d /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/
       	unzip /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/ChangeO_prod_unprod-20260109T180954Z-3-006.zip -d /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/
}

function rename_files {
	mkdir /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/IGK
	mkdir /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/IGL
	
	mv /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/master_changeo_mutated_500_seqs_filtered_productive-003.tsv /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/IGK/master_changeo_mutated_500_seqs_filtered_productive.tsv
        mv /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/master_changeo_unmutated_500_seqs_filtered_productive-005.tsv /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/IGK/master_changeo_unmutated_500_seqs_filtered_productive.tsv
	mv /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/master_changeo_mutated_500_seqs_filtered_productive-004.tsv /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/IGL/master_changeo_mutated_500_seqs_filtered_productive.tsv
	mv /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/master_changeo_unmutated_500_seqs_filtered_productive.tsv /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/IGL/master_changeo_unmutated_500_seqs_filtered_productive.tsv
	
}

function get_unproductive {
	# Google Drive sends files in confusing chunks, so I zipped four files explicitly. Next time I do an experiment like this I'll probably get each file explicitly even if it takes forever to download the unzipped versions. Command from my computer:
	# zip changeo_unproductive.zip /home/franklin/Downloads/ChangeO_prod_unprod-20260109T180954Z-3-006/ChangeO_prod_unprod/IGL/mutated/unproductive/master_changeo_mutated_500_seqs_filtered_unproductive.tsv /home/franklin/Downloads/ChangeO_prod_unprod-20260109T180954Z-3-002/ChangeO_prod_unprod/IGK/mutated/unproductive/master_changeo_mutated_500_seqs_filtered_unproductive.tsv /home/franklin/Downloads/ChangeO_prod_unprod-20260109T180954Z-3-002/ChangeO_prod_unprod/IGK/unmutated/unproductive/master_changeo_unmutated_500_seqs_filtered_unproductive.tsv /home/franklin/Downloads/ChangeO_prod_unprod-20260109T180954Z-3-002/ChangeO_prod_unprod/IGL/unmutated/unproductive/master_changeo_unmutated_500_seqs_filtered_unproductive.tsv
	# scp it into /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/
	:
}

function unzip_unproductive {
	# made a mistake on the zipping stage, so the files are at i.e. /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/changeo_unproductive/home/franklin/Downloads/ChangeO_prod_unprod-20260109T180954Z-3-002/ChangeO_prod_unprod/IGL/unmutated/unproductive/
	
	unzip -d /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/changeo_unproductive /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/changeo_unproductive.zip	
}

function move_unproductive {
	
	mv /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/changeo_unproductive/home/franklin/Downloads/ChangeO_prod_unprod-20260109T180954Z-3-002/ChangeO_prod_unprod/IGK/mutated/unproductive/master_changeo_mutated_500_seqs_filtered_unproductive.tsv /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/IGK/master_changeo_mutated_500_seqs_filtered_unproductive.tsv
	mv /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/changeo_unproductive/home/franklin/Downloads/ChangeO_prod_unprod-20260109T180954Z-3-002/ChangeO_prod_unprod/IGK/unmutated/unproductive/master_changeo_unmutated_500_seqs_filtered_unproductive.tsv /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/IGK/master_changeo_unmutated_500_seqs_filtered_unproductive.tsv
	mv /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/changeo_unproductive/home/franklin/Downloads/ChangeO_prod_unprod-20260109T180954Z-3-002/ChangeO_prod_unprod/IGL/unmutated/unproductive/master_changeo_unmutated_500_seqs_filtered_unproductive.tsv /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/IGL/master_changeo_unmutated_500_seqs_filtered_unproductive.tsv
	mv /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/changeo_unproductive/home/franklin/Downloads/ChangeO_prod_unprod-20260109T180954Z-3-006/ChangeO_prod_unprod/IGL/mutated/unproductive/master_changeo_mutated_500_seqs_filtered_unproductive.tsv /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/IGL/master_changeo_mutated_500_seqs_filtered_unproductive.tsv
}


#download_changeo
#unzip_changeo
#rename_files
#unzip_unproductive
move_unproductive

