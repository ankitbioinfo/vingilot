#! /bin/bash

path="/data/gruen/repository/kallisto_indices"

index=$path/"mouse/Mus_musculus.GRCm38.99.cDNA.idx"
whitelist=$path/"whitelists/celseq_barcodes.192.whitelist.txt"
cDNA_to_genes=$path/"mouse/Mus_musculus.GRCm38.99.cDNA.transcripts_to_genes.gene_symbol.txt"

# 192 barcodes
whitelist=$path/"whitelists/celseq_barcodes.192.whitelist.txt"
flag="0,6,12:0,0,6:1,0,0"

# 384 barcodes
# whitelist=$path/"whitelists/celseq_barcodes.384.whitelist.txt"
# flag="0,7,14:0,0,7:1,0,0"

fastq1="/data/gruen/group/peltokangas/Project_1023/19082019/E11-PL-CD31Kit-m1-100419-1_R1.fastq.gz"
fastq2="/data/gruen/group/peltokangas/Project_1023/19082019/E11-PL-CD31Kit-m1-100419-1_R2.fastq.gz"

kallisto bus -i $index -o out_cDNA/ -x $flag $fastq1 $fastq2
cd out_cDNA/
mkdir -p counts/
bustools_dev correct -w $whitelist -p output.bus | bustools sort -o output.correct.sort.bus -t 4 -
bustools_dev count -o counts/result_dev -g $cDNA_to_genes -e matrix.ec -t transcripts.txt --umi-gene --genecounts output.correct.sort.bus
