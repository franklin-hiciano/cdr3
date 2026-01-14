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
  module load R
  mkdir -p "/sc/arion/work/hiciaf01/projects/cdr3/results/2025-11-06_light_chain_changeos/R/count_clones"
	for locus in IGK IGL
do
	for SHM_status in mutated unmutated
	do
		for functional in productive unproductive
		do

  job_name="count_clones"
	bsub \
	-P acc_oscarlr \
    	-q express \
    	-W 01:00 \
    	-n 4 \
    	-J "${job_name}" \
    	-R "span[hosts=1]" \
    	-R "rusage[mem=8000]" \
    	-o "/sc/arion/work/hiciaf01/projects/cdr3/results/2025-11-06_light_chain_changeos/R/count_clones/count_clones.out" \
    	-e "/sc/arion/work/hiciaf01/projects/cdr3/results/2025-11-06_light_chain_changeos/R/count_clones/count_clones.%J.err" \
    	"module load R; Rscript ${SCRIPT} ${CHANGEO_DIR} ${OUT_DIR} ${locus} ${SHM_status} ${functional}"
done
done
done
}


#changeo_subset
#process_changeo
validate_process_changeo_results_using_bash
