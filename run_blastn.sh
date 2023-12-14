#!/bin/bash

cd ~/Initial_Test_metaMATE/
mkdir blastn

# Ejecutar la linea
blastn -db ./All_Refrences_METAMATE -query ./RELABEL/all.ZOTUS_UNIQUES.FV.fas -gapopen 4 -gapextend 2 -outfmt 5 -out ./blastn/all.ZOTUS_UNIQUES.FV_Vs_COX1bold_REFs_2022.xml -num_threads=16 -evalue 0.000000000000000000000000001 -max_target_seqs 100 
