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
    fastqc -o fastqc_raw ../01_raw_Rep1_r1_r2_ordered/*/*.fastq.gz
fi

# Trim primers
if [ ! -d "cutadapt/" ]
then
    mkdir cutadapt
    cd /Datos/mockcommunities_EPA45/epa45_metabarcodes/sequences/01_raw_Rep1_r1_r2_ordered/
    for file in */*.fastq.gz
    do        
        echo ${file} 	    
        cutadapt -j 16 -g ^CCNGAYATRGCNTTYCCNCG -g ^CNGAYATRGCNTTYCCNCG -g ^NGAYATRGCNTTYCCNCG -g ^GAYATRGCNTTYCCNCG -g ^AYATRGCNTTYCCNCG -G ^TCNGGRTGNCCRAARAAYCA \
        -G ^CNGGRTGNCCRAARAAYCA -G ^NGGRTGNCCRAARAAYCA -G ^GGRTGNCCRAARAAYCA -G ^GRTGNCCRAARAAYCA ${file} -o ../../02_preprocessed/cutadapt/${file%.*}.cutadapt.fq
    done
fi
