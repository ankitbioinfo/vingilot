#! /bin/bash

path="/data/gruen/repository/kallisto_indices"

index=$path/"human/Homo_sapiens.GRCh38.99.cDNA.idx"
whitelist=$path/"whitelists/10xv3_whitelist.txt"
cDNA_to_genes=$path/"human/Homo_sapiens.GRCh38.99.cDNA.transcripts_to_genes.gene_symbol.txt"


# Download http://cf.10xgenomics.com/samples/cell-exp/3.0.0/pbmc_1k_v3/pbmc_1k_v3_fastqs.tar
# tar xvf pbmc_1k_v3_fastqs.tar

kallisto bus -i $index -o out_cDNA/ -x 10xv3 -t 4 pbmc_1k_v3_fastqs/pbmc_1k_v3_S1_L001_R1_001.fastq.gz pbmc_1k_v3_fastqs/pbmc_1k_v3_S1_L001_R2_001.fastq.gz pbmc_1k_v3_fastqs/pbmc_1k_v3_S1_L002_R1_001.fastq.gz pbmc_1k_v3_fastqs/pbmc_1k_v3_S1_L002_R2_001.fastq.gz 
cd out_cDNA/
mkdir -p counts/
bustools_dev correct -w $whitelist -p output.bus | bustools sort -o output.correct.sort.bus -t 4 -
bustools_dev count -o counts/result_dev -g $cDNA_to_genes -e matrix.ec -t transcripts.txt --umi-gene --genecounts output.correct.sort.bus
