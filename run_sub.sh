#!/bin/bash

# Script to preprocess raw metabarcoding data

# Load conda environment
source /opt/miniconda3/etc/profile.d/conda.sh
conda activate metamate_env

# Change working directory to the correct location
#cd "$1"
cd /Datos/mockcommunities_EPA45/epa45_metabarcodes/sequences/02_preprocessed

# Run fastqc on all fastq files
if [ ! -d "fastqc_raw/" ]
then 
    mkdir fastqc_raw
    fastqc -o fastqc_raw ../01_raw/LIFEPLAN-00001/*.fastq.gz
fi

# Trim primers
# TODO rewrite primer trimming. Could be incooperated in trimmomatic
# First two bases of EPA45 reads already trimmed
if [ ! -d "PTRIM/" ]
then
    mkdir PTRIM
    cd /Datos/mockcommunities_EPA45/epa45_metabarcodes/sequences/01_raw/LIFEPLAN-00001
    N=16    
    for file in *Rep1.R1.fastq.gz
    do        
        ((i=i%N)); ((i++==0)) && wait
        echo ${file} 	    
        gunzip -c ${file} | fastx_trimmer -f 19 -o ../../02_preprocessed/PTRIM/${file%.*}.Ptrim.fq &
    done

	N=16    
    for file in *Rep1.R2.fastq.gz
    do        
        ((i=i%N)); ((i++==0)) && wait
        echo ${file} 	    
        gunzip -c ${file} | fastx_trimmer -f 19 -o ../../02_preprocessed/PTRIM/${file%.*}.Ptrim.fq &
    done

fi
