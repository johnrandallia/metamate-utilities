#!/bin/bash

# Script to preprocess raw metabarcoding data

# Load conda environment
source /opt/miniconda3/etc/profile.d/conda.sh
conda activate metamate_env

# Change working directory to the correct location
cd ~/Initial_Test_metaMATE/raw_reads

# Run fastqc on all fastq files
if [ ! -d "../fastqc_raw" ]
then 
    mkdir ../fastqc_raw
    fastqc -o ../fastqc_raw *.fastq
fi

# Trim primers
# TODO rewrite primer trimming. Could be incooperated in trimmomatic
if [ ! -d "../PTRIM" ]
then
    mkdir ../PTRIM
    for file in *R1_001.fastq
    do
	    fastx_trimmer -f 21 -i ${file} -o ../PTRIM/${file%.*}.Ptrim.fq
    done

    for file in *R2_001.fastq
    do
	    fastx_trimmer -f 27 -i ${file} -o ../PTRIM/${file%.*}.Ptrim.fq
    done
fi

# Remove ends with low quality
if [ ! -d "../TRIMMO" ]
then
    cd ../PTRIM
    mkdir ../TRIMMO
    for file in *Ptrim.fq
    do
        trimmomatic SE -threads 4 -phred33 -trimlog ../TRIMMO/$file.log -summary ../TRIMMO/$file.summary.log $file ../TRIMMO/$file.trimmo.fq TRAILING:20
    done
fi

# perform another fastqc with trimmed reads
if [ ! -d "../fastqc_after_trimmo" ]
then
    cd ../TRIMMO
    mkdir ../fastqc_after_trimmo
    fastqc -o ../fastqc_after_trimmo *.fq
fi

# Pair fastq reads
if [ ! -d "../PAIRED" ]
then
    cd ../TRIMMO
    mkdir ../PAIRED

    for f1 in *R1*trimmo.fq
    do
	    echo $f1
	    part1="$(echo $f1 | sed 's/\(.*\)R1.*/\1/')" 
	    part2="$(echo $f1 | sed 's/.*R1\(.*\)/\1/')"
	    
	    f2="$part1"
        f2+="R2"
		f2+="$part2"
		        
	    echo "file1: $f1"
	    echo "file2: $f2"
	    echo "executing pairfq_lite ..."

        fastq_pair $f1 $f2  
	    echo "done"
     	
    done
    mv *paired.fq ../PAIRED/
    mv *single.fq ../PAIRED/
fi


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
	    part3="$(echo $f1 | sed 's/\(.*\)_L001.*/\1/')"
	    part4="$(echo $f1 | sed 's/\(.*\)_L001_R1\(.*\)Ptrim.*/\2/')"
	    
	    
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
	    
        # TODO: add usearch to github folder
	    ~/usearch11.0.667_i86linux32 -fastq_mergepairs $f1 -reverse $f2 -fastq_minovlen 50 -fastq_maxdiffs 15 -fastq_pctid 50 -fastqout ../MergePair/$f3 -report ../MergePair/$f4 
	    echo "done"
     done
fi


# maxee1
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

	    ~/usearch11.0.667_i86linux32 -fastq_filter $f1 -fastq_maxee 1 -fastaout ../maxee1/$f2 &> ../maxee1/$f3
	    
	    echo "done"
     done
fi

 
#LABELLING by library and primer
if [ ! -d "../LABEL_lib" ]
then
    cd ../maxee1
    mkdir ../LABEL_lib

    for file in *.fas
    do
	    part1="$(echo $file | sed 's/\(.*\)_R1.*.*/\1/')" 
	    label="$part1"
		    
	    echo $file
	    echo $label
        sed "-es/^>\(.*\)/>\1;barcodelabel=$label;/" < ${file} > ../LABEL_lib/${file%.*}.labelbyLIB.fas
    done
fi




#SortLength_uniques_denoise_420.sh
#sortbylength and keeping only reads of 420 on labelling by lib
if [ ! -d "../LENGTH416_420" ]
then
    cd ../LABEL_lib
    mkdir ../LENGTH416_420

    for f1 in *labelbyLIB.fas
    do
	    
	    echo $f1
	    part1="$(echo $f1 | sed 's/\(.*\)fas*/\1/')" 

	    f2="$part1"
        f2+="sorted416_420.fas"
	    f2log="$part1"
	    f2log+="sorted416_420.log"
				    
	    echo "input: $f1"
	    echo "output: $f2"
	    echo "executing sortbylength 420 ..."
	    
	    ~/usearch11.0.667_i86linux32 -sortbylength $f1  -fastaout ../LENGTH416_420/$f2 -minseqlength 416 -maxseqlength 420 &> ../LENGTH416_420/$f2log
	    
	    echo "done sortbylength 416-420 ..."
    done		

fi




#sortbylength and keeping only reads of 418 (exact length) + - 2 (416-4120) on labelling by lib and primer (normal path)		
#Combine by sample
if [ ! -d "../UNIQUESbyLIB" ]
then
    cd ../LENGTH416_420
    mkdir ../UNIQUESbyLIB

    for f1 in *sorted416_420.fas
    do
	    
	    echo $f1
	    part1="$(echo $f1 | sed 's/\(.*\)fas*/\1/')" 

	    f2="$part1"
        f2+="uniques.fas"
	    f2log="$part1"
	    f2log+="uniques.log"
	    
        echo "input: $f1"
	    echo "output: $f2"			
	    echo "executing fastx_uniques ..."
	    ~/usearch11.0.667_i86linux32 -fastx_uniques ./$f1 -fastaout ../UNIQUESbyLIB/$f2 -sizeout &> ../UNIQUESbyLIB/$f2log
	    echo "done fastx_uniques ..."
     		
    done			
fi
 

#unosie3 by lib
if [ ! -d "../UNOISE" ]
then
    cd ../UNIQUESbyLIB
    mkdir ../UNOISE
        
    for f1 in *uniques.fas
    do
        
        echo $f1
        part1="$(echo $f1 | sed 's/\(.*\)fas*/\1/')" 			
        f2="$part1"
        f2+="zotus.fas"
        f2log="$part1"
        f2log+="zotus.log"
        f2tabout="$part1"
        f2tabout+="zotus.tabbedout.txt"
					        
        echo "input: $f1"
        echo "output: $f2"
        echo "executing unoise3 ..."
        ~/usearch11.0.667_i86linux32 -unoise3 ./$f1 -zotus ../UNOISE/$f2 -minsize 2 -tabbedout ../UNOISE/$f2tabout &>../UNOISE/$f2log
        echo "done unoise3 ..."
     
     done
fi


# RELABEL
if [ ! -d "../RELABEL" ]
then
    cd ../UNOISE
    mkdir ../RELABEL
    for file in *zotus.fas
    do	
	    part1="$(echo $file | sed 's/\(.*\)_R1.*.*/\1/')" 
	    
	    label="$part1"
	    
	    echo $file
	    echo $label
        sed "-es/^>\(.*\)/>\1_$label/" < ${file} > ../RELABEL/${file%.*}.relabel.fas
     
    done

    # Join all zotus individuals
    cd ../RELABEL
    cat *relabel.fas > all.ZOTUSbySAMPLE.FV.fas

    # Only keep uniques
    ~/usearch11.0.667_i86linux32 -fastx_uniques all.ZOTUSbySAMPLE.FV.fas -fastaout all.ZOTUS_UNIQUES.FV.fas -sizeout &> all.ZOTUS_UNIQUES.FV.log
fi







