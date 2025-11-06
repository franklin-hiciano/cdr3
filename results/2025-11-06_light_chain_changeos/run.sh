#!/bin/bash
set -e -x
set -euo pipefail


function download_changeo {
	# from https://drive.google.com/file/d/1acJkm2RtxALwEQHxUwP6inbXMQ1vOoLr/view?usp=drive_link
}

function split_file {
	for chain in IGK IGL
do
	awk -v -s=${chain} '{if ($?? == s) print $0}' > ${chain}.tsv
done
}


split_file
