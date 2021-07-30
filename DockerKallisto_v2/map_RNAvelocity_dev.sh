#! /bin/bash

path="/data/gruen/repository/kallisto_indices"

index=$path/"human/Homo_sapiens.GRCh38.99.cDNA_intron.idx"
whitelist=$path/"whitelists/10xv3_whitelist.txt"
cDNA_to_capture=$path/"human/Homo_sapiens.GRCh38.99.cDNA.transcripts_to_capture.txt"
intron_to_capture=$path/"human/Homo_sapiens.GRCh38.99.intron.transcripts_to_capture.txt"
cDNA_intron_to_genes=$path/"human/Homo_sapiens.GRCh38.99.cDNA_intron.transcripts_to_genes.gene_symbol.txt"


# Download http://cf.10xgenomics.com/samples/cell-exp/3.0.0/pbmc_1k_v3/pbmc_1k_v3_fastqs.tar
# tar xvf pbmc_1k_v3_fastqs.tar

kallisto bus -i $index -o out/ -x 10xv3 -t 4 pbmc_1k_v3_fastqs/pbmc_1k_v3_S1_L001_R1_001.fastq.gz pbmc_1k_v3_fastqs/pbmc_1k_v3_S1_L001_R2_001.fastq.gz pbmc_1k_v3_fastqs/pbmc_1k_v3_S1_L002_R1_001.fastq.gz pbmc_1k_v3_fastqs/pbmc_1k_v3_S1_L002_R2_001.fastq.gz 
cd out/
mkdir -p cDNA_capture/ introns_capture/ spliced/ unspliced/ tmp/
bustools_dev correct -w $whitelist -p output.bus | bustools sort -o output.correct.sort.bus -t 4 -
bustools_dev capture -o cDNA_capture/split.bus -c $cDNA_to_capture -s -e matrix.ec -t transcripts.txt output.correct.sort.bus
bustools_dev capture -o introns_capture/split.bus -c $intron_to_capture -s -e matrix.ec -t transcripts.txt output.correct.sort.bus
bustools_dev count -o unspliced/u -g $cDNA_intron_to_genes -e matrix.ec -t transcripts.txt --umi-gene --genecounts introns_capture/split.bus
bustools_dev count -o spliced/s -g $cDNA_intron_to_genes -e matrix.ec -t transcripts.txt --umi-gene --genecounts cDNA_capture/split.bus
