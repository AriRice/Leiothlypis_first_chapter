#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=extract_mito_genome
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-38
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL

# define main working directory
workdir=/lustre/scratch/arrice/Ch1_Leiothlypis

basename_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/basenames.txt | tail -n1 )

# run bbsplit
/lustre/work/jmanthey/bbmap/bbsplit.sh in1=${workdir}/01_cleaned/${basename_array}_R1.fastq.gz in2=${workdir}/01_cleaned/${basename_array}_R2.fastq.gz ref=${mito} basename=${workdir}/01b_mtDNA/${basename_array}_%.fastq.gz outu1=${workdir}/01_mtDNA/${basename_array}_R1.fastq.gz outu2=${workdir}/01b_mtDNA/${basename_array}_R2.fastq.gz

# remove unnecessary bbsplit output files
rm ${workdir}/01b_mtDNA/${basename_array}_R1.fastq.gz
rm ${workdir}/01b_mtDNA/${basename_array}_R2.fastq.gz
