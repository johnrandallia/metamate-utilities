#!/bin/bash

# Installation of Utilities

conda install -c bioconda fastqc
conda install -c bioconda fastx_toolkit
conda install -c bioconda fastq-pair
conda install -c bioconda trimmomatic
conda install -c "bioconda/label/cf201901" samtools
conda install -c bioconda vsearch
conda install -c conda-forge pigz
conda install biopython

sudo apt install cutadapt
pip3 install levenshtein

conda install -c bioconda bfc
conda install -c adriantich dnoise

conda install -c conda-forge r-base=4.0.0
