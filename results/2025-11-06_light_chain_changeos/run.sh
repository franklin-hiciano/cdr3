#!/bin/bash
set -e -x
set -euo pipefail


function download_changeo {
	# from https://drive.google.com/file/d/1acJkm2RtxALwEQHxUwP6inbXMQ1vOoLr/view?usp=drive_link to /sc/arion/scratch/hiciaf01/projects/cdr3/data/2025-11-06_light_chain_changeos/changeo/master_changeo_2.deheader.tsv
}

function split_file {
	module load python
	python run.py	
}

split_file
