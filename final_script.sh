#!/bin/bash

source ~/miniforge3/etc/profile.d/conda.sh

#make sure you have conda env ex3 with all required packages installed 
conda activate ex3

#check utility version to confirm proper installation
fasterq-dump --version
fastp --version
skesa --version
trimmomatic -version
spades.py --version
./fast_stats.py --help
./filter.contigs.py --help


#accessing file names
sample='B0993986' #REPLACE WITH FILE 
filename1=${sample}_S01_L001_R1_001.fastq
filename2=${sample}_S01_L001_R2_001.fastq

#gunzip files
gzip ./raw_reads/"${filename1}"
gzip ./raw_reads/"${filename2}"



#INITIAL QUALITY ASSESSMENT USING FASTQC-------------------------------

#make sure raw data is in raw_data

#create new directory for quality assessment and go to it
mkdir raw_qa
cd raw_qa

#view assessment using fastqc

fastqc \
    --threads 2 \
    --outdir . \
    ../raw_reads/"${filename1}.gz" \
    ../raw_reads/"${filename2}.gz" \
    1> "${sample}.fastqc.stdout.log" \
    2> "${sample}.fastqc.stderr.log" 

#open html
#open ./*.html

#go back to main directory
cd ..

#TRIM USING FASTP ----------------------------------------

#create new directory for cleaning and go to it
mkdir trim
cd trim

#trim
(/usr/bin/time -l fastp \
    -i ../raw_reads/"${filename1}.gz" \
    -I ../raw_reads/"${filename2}.gz" \
    -o ./"${filename1}.out.fq.gz" \
    -O ./"${filename2}.out.fq.gz" \
    --unpaired1 ./"${filename1}.unpaired_out.fq.gz" \
    --unpaired2 ./"${filename2}.unpaired_out.fq.gz" \
    -A \
    -e 30 \
    -l 125 \
    1> "${sample}.fastp.stdout.log" )\
    2> "${sample}.fastp.stderr.log" 

#go back to main directory
cd ..


#ASSEMBLE USING SKESA ------------------------------------------------

#create new directory for cleaning and go to it
mkdir asm
cd asm

#asm
(/usr/bin/time -l skesa \
    --reads ../trim/"${filename1}.out.fq.gz" ../trim/"${filename2}.gz" \
    --contigs_out "${sample}.skesa_assembly.fna"\
    1> "${sample}.skesa.stdout.log" )\
    2> "${sample}.skesa.stderr.log"


#go back to main directory
cd ..



#ASSESSMENT USING FILTER.CONTIGS -----------------------------------

mkdir fil_con


#perform filter.contigs
./filter.contigs.py \
    --infile asm/"${sample}.skesa_assembly.fna" \
    --outfile fil_con/"${sample}.filtered-contigs.fa"\
    --discarded fil_con/"${sample}.removed-contigs.fa" \
    1> fil_con/"${sample}.filter-contigs.stdout.log" \
    2> fil_con/"${sample}.filter-contigs.stderr.log"



#ASSESSMENT USING QUAST-----------------------------------

#create new directory for cleaning and go to it
mkdir quast
cd quast

#perform quast with new env quast_env with quast installed
conda deactivate
conda activate quast_env

#check utility version to confirm proper installation
quast --version

#perform quast
quast ../asm/"${sample}.skesa_assembly.fna" -o ./"${sample}.quast_output"

conda deactivate
