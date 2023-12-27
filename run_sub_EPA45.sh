#!/bin/bash

# Script to preprocess raw metabarcoding data

# Load conda environment
source /opt/miniconda3/etc/profile.d/conda.sh
conda activate metamate_env

# Change working directory to the correct location
#cd "$1"
cd /Datos/mockcommunities_EPA45/epa45_metabarcodes/sequences/02_preprocessed/TRIMMO

# Merge the pairs
if [ ! -d "../MergePair" ]
then
    cd ../PAIRED
    mkdir ../MergePair

    for f1 in *R1*trimmo.fq.paired.fq
    do
	    echo $f1
	    #para inputs
	    part1="$(echo $f1 | sed 's/\(.*\)R1.*/\1/')" 
	    part2="$(echo $f1 | sed 's/.*R1\(.*\)/\1/')"
	    
	    f2="$part1"
	    f2+="R2"
	    f2+="$part2"
	    
        #para outputs
	    part3="$(echo $f1 | sed 's/\(.*\)_Rep1.*/\1/')"
	    #part4="$(echo $f1 | sed 's/\(.*\)_Rep1.R1\(.*\)Ptrim.*/\2/')"
	    part4="_Rep1_"

	    f3="$part3"
	    f3+="$part4"
	    f3+="R1_R2.Ptrim.trimmo.fastq"
	    
	    f4="$part3"
	    f4+="$part4"
	    f4+="R1_R2.Ptrim.trimmo.report.log"
	    
	    echo "file1: $f1"
	    echo "file2: $f2"
	    echo "file3: $f3"

	    echo "executing fastq_mergepairs ..."
	    
	    ~/usearch11.0.667_i86linux32 -threads 16 -fastq_mergepairs $f1 -reverse $f2 -fastq_maxdiffs 10 -fastq_pctid 80 -fastqout ../MergePair/$f3 -report ../MergePair/$f4 
	    echo "done"
     done
fi


# discard sequences with a maximum expected error (maxee)>2
if [ ! -d "../maxee1" ]
then
    cd ../MergePair
    mkdir ../maxee1

    for f1 in *R1_R2.Ptrim.trimmo.fastq
    do
	    echo $f1
	    part1="$(echo $f1 | sed 's/\(.*\)fastq*/\1/')"    

	    f2="$part1"
        f2+="Maxee1.fas"

		f3="$part1"
        f3+="Maxee1.log"

	    echo "input: $f1"
	    echo "output: $f2"
	    echo "logfile: $f3"

	    echo "executing maxee 1 ..."

	    ~/usearch11.0.667_i86linux32 -threads 16 -fastq_filter $f1 -fastq_maxee 1 -fastaout ../maxee1/$f2 &> ../maxee1/$f3
	    
	    echo "done"
     done
fi



