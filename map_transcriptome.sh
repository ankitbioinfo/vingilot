#! /bin/bash

start=$SECONDS
echo "time start $start"

path="/scratch/gruenlab/repository/kallisto_indices"
#path="/home/ext/agrawal/kallisto_indices"
index=$path/"mouse/Mus_musculus.GRCm38.99.cDNA.idx"
whitelist=$path/"whitelists/10xv3_whitelist.txt"
cDNA_to_genes=$path/"mouse/Mus_musculus.GRCm38.99.cDNA.transcripts_to_genes.gene_symbol.txt"

data_input_path="/home/ext/agrawal/FastqFiles/merged_files"
outpath1="/home/ext/agrawal/FastqFiles/out_cDNA"
outpath2="/home/ext/agrawal/FastqFiles/counts"

mkdir -p $outpath1
kallisto bus -i $index -o $outpath1 -x 10xv3 -t 4 $data_input_path/E115_R1.fastq.gz  $data_input_path/E115_R2.fastq.gz
cd $outpath1

mkdir -p $outpath2
bustools correct -w $whitelist -p output.bus | bustools sort -o output.correct.sort.bus -t 4 -
bustools count -o $outpath2/result -g $cDNA_to_genes -e matrix.ec -t transcripts.txt --genecounts output.correct.sort.bus -m

duration=$((SECONDS-start))

echo "finish time in seconds = $duration"
