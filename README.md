# Fastp and Skesa Processing Results

This directory contains the results of read trimming and genome assembly performed using Fastp and Skesa. These final results are accompanied fastp logs, skesa logs, and final assembly faa files for reference. Quality control (QC) reports, which are common across tools, are stored separately.

# Contents
- Final Results: Outputs from fastp and skesa.
- Logs: Includes logs from Fastp and Skesa for reference and reproducibility.

# System Specifications
The following OS and hardware specifications were used for processing:
- Architecture: arm64 (Apple Silicon)
- Chip: Apple M1
- Cores: 8 (4 performance cores + 4 efficiency cores)
- Memory: 16 GB RAM
- Operating System: Darwin

# Tools Used
- FastQC: v0.12.1 (for quality control of raw and trimmed reads)
- Fastp: 0.22.0 (for read trimming and adapter removal)
- Skesa: 2.5.1 (for genome assembly)
- Quast: 5.0.0
- Python: 2.7.15

# Workflow Overview
- Quality Control:
FastQC was used to generate initial QC reports for raw sequencing reads.
- Read Trimming:
Fastp was used to trim adapters and low-quality bases. Both paired and unpaired reads were generated and used as inputs for the subsequent assembly step.
- Genome Assembly:
Skesa was used to assemble the processed reads into contigs.

# File Structure
- `Assembly_Log_Files`: Log file for standard error output from the skesa assembly step.
- `QUAST_Files`: Quast results.txt files after assembly.
- `FastA_Files`: FASTA file containing the filtered contigs.


