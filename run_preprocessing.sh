#!/bin/bash

# Script to preprocess raw metabarcoding data 

# run fastqc on all fastq files
# TODO generate results in separate folder
fastqc *.fastq

# trim primers 
# TODO check if new file needs to be created with fastx_trimmer
# create new 
for file in *R1_001.fastq
do
	fastx_trimmer -f 21 -i ${file} -o ./PTRIM/${file%.*}.Ptrim.fq 
done

for file in *R2_001.fastq
do
	fastx_trimmer -f 27 -i ${file} -o ./PTRIM/${file%.*}.Ptrim.fq 
done

# 
