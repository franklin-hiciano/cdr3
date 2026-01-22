#!/bin/bash
set -e -x
set -euo pipefail
DATA="/sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/"
RESULTS="/sc/arion/work/hiciaf01/projects/cdr3/results/2025-11-06_light_chain_changeos/"

function download_changeo {
	:	
	# from https://drive.google.com/file/d/1acJkm2RtxALwEQHxUwP6inbXMQ1vOoLr/view?usp=drive_link to /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/master_changeo_2.deheader.tsv
}

function changeo_subset {
	#function for testing the pipeline
	head -n 5 $DATA/changeo/master_changeo_2.deheader.tsv > $DATA/changeo/changeo_subset.tsv
}

function process_changeo {
	module load python

	for locus in IGK IGL
do
	job_name="process_changeo_${locus}"
	bsub \
		-P acc_oscarlr \
	       	-q express \
		-W 0:30 \
		-n 6 \
		-J ${job_name} \
		-R span[hosts=1] \
		-R rusage[mem=6000] \
		-o ${job_name}.out \
		-e ${job_name}.err \
		"python process_changeo.py --changeo $DATA/changeo/master_changeo_2.deheader.tsv --locus ${locus} --v_identity 100 --j_identity 100 --outfile ${RESULTS}/${locus}.tsv"
done
}

function validate_process_changeo_results_using_bash {
	for locus in IGK IGL
do
	cat $DATA//changeo/master_changeo_2.deheader.tsv | cut -f5,17,75,77 | grep "${locus}"
done
}

function count_clones {
	# should be named: count_unique_clones_by_sample. also used the word 'distinct' when it should be 'unique'
  	module load R
	mkdir -p "${RESULTS}/R/count_clones/"
	mkdir -p "${RESULTS}/R/count_clones/logs"
	for locus in IGK IGL
do
	for SHM_status in mutated unmutated
	do
		for functional in productive unproductive
		do

			job_name="count_clones_${locus}_${SHM_status}_${functional}"
			bsub \
				-P acc_oscarlr \
    				-q express \
    				-W 01:00 \
    				-n 1 \
    				-J "${job_name}" \
    				-R "span[hosts=1]" \
    				-R "rusage[mem=16000]" \
    				-o "/sc/arion/work/hiciaf01/projects/cdr3/results/2025-11-06_light_chain_changeos/R/count_clones/logs/${job_name}.out" \
    				-e "/sc/arion/work/hiciaf01/projects/cdr3/results/2025-11-06_light_chain_changeos/R/count_clones/logs/${job_name}.err" \
    				"module load R; Rscript ${RESULTS}/R/count_clones.R distinct ${DATA}/changeo/${locus}/master_changeo_${SHM_status}_500_seqs_filtered_${functional}.tsv ${RESULTS}/R/count_clones/clone_counts_${locus}_${SHM_status}_${functional}.tsv"
		done
	done
done
}

function sum_clones {
	# poorly named: sum_unique_clones_across_all_samples_by_loci
	printf "sample_id\tunique_clones" 
	for locus in IGK IGL
do
        clone_counts_tables=()
	for SHM_status in mutated unmutated
        do
                for functional in productive unproductive
                do
			clone_counts_tables+=("${RESULTS}/R/count_clones/clone_counts_${locus}_${SHM_status}_${functional}.tsv")
                done
        done
	printf "sample_id\tunique_clones\n" > "${RESULTS}/R/count_clones/summed_clone_counts_${locus}.tsv"
	awk '{sample_id=$1; v=$2+0 ; sum[sample_id]+=v} END{for (sample_id in sum) print sample_id "\t" sum[sample_id]} ' "${clone_counts_tables[@]}" | sort -k1,1 >> "${RESULTS}/R/count_clones/summed_clone_counts_${locus}.tsv"
done
}

# changed our approach from this one.
function sum_all_clones {
		# should be named: count_all_clones_across_files_by_loci
        printf "sample_id\tunique_clones"
        for locus in IGK IGL
do
        clone_counts_tables=()
        for SHM_status in mutated unmutated
        do
                for functional in productive unproductive
                do
                        clone_counts_tables+=("${RESULTS}/R/count_all_clones/clone_counts_${locus}_${SHM_status}_${functional}.tsv")
                done
        done
        printf "sample_id\tunique_clones\n" > "${RESULTS}/R/count_all_clones/summed_clone_counts_${locus}.tsv"
	awk 'FNR > 1 {count=$1; sum+=count; print("HI")} END{print sum} ' "${clone_counts_tables[@]}" | sort -k1,1 >> "${RESULTS}/R/count_all_clones/summed_clone_counts_${locus}.tsv"
done
}


function count_all_clones {
		# should be named: count_all_B_cells_by_file
        module load R
        mkdir -p "${RESULTS}/R/count_all_clones/"
        mkdir -p "${RESULTS}/R/count_all_clones/logs"
        for locus in IGK IGL
do
        for SHM_status in mutated unmutated
        do
                for functional in productive unproductive
                do

                        job_name="count_all_clones_${locus}_${SHM_status}_${functional}"
                        bsub \
                                -P acc_oscarlr \
                                -q express \
                                -W 01:00 \
                                -n 1 \
                                -J "${job_name}" \
                                -R "span[hosts=1]" \
                                -R "rusage[mem=16000]" \
                                -o "${RESULTS}/R/count_all_clones/logs/${job_name}.out" \
                                -e "${RESULTS}/R/count_all_clones/logs/${job_name}.err" \
                                "module load R; Rscript ${RESULTS}/R/count_clones.R all ${DATA}/changeo/${locus}/master_changeo_${SHM_status}_500_seqs_filtered_${functional}.tsv ${RESULTS}/R/count_all_clones/clone_counts_${locus}_${SHM_status}_${functional}.tsv"
                done
        done
done
}

function count_all_clones_per_sample {
		# should be named: count_all_B_cells_by_sample
        module load R
        mkdir -p "${RESULTS}/R/count_all_clones_per_sample/"
        mkdir -p "${RESULTS}/R/count_all_clones_per_sample/logs"
        for locus in IGK IGL
do
        for SHM_status in mutated unmutated
        do
                for functional in productive unproductive
                do

                        job_name="count_all_clones_per_sample${locus}_${SHM_status}_${functional}"
                        bsub \
                                -P acc_oscarlr \
                                -q express \
                                -W 01:00 \
                                -n 1 \
                                -J "${job_name}" \
                                -R "span[hosts=1]" \
                                -R "rusage[mem=16000]" \
                                -o "${RESULTS}/R/count_all_clones_per_sample/logs/${job_name}.out" \
                                -e "${RESULTS}/R/count_all_clones_per_sample/logs/${job_name}.err" \
                                "module load R; Rscript ${RESULTS}/R/count_clones.R all_per_sample ${DATA}/changeo/${locus}/master_changeo_${SHM_status}_500_seqs_filtered_${functional}.tsv ${RESULTS}/R/count_all_clones_per_sample/clone_counts_${locus}_${SHM_status}_${functional}.tsv"
                done
        done
done
}

#changeo_subset
#process_changeo
#validate_process_changeo_results_using_bash
#count_clones
#sum_clones
count_all_clones_per_sample
#count_all_clones
#sum_all_clones
