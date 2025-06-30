#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=Ch1_filter_contam_check
#SBATCH --nodes=1 --ntasks=1
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-30
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL

module load intel/18.0.3.222 vcftools/0.1.16

# define main working directory
workdir=/lustre/scratch/arrice/Ch1_Leiothlypis

# define input files from helper file during genotyping
region_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/scaffolds_minus_sex.txt | tail -n1 )

# filtering for contamination check
vcftools --vcf ${workdir}/04_filtered_vcf/${region_array}.vcf --remove outgroup.txt --minGQ 20 --minDP 6 --max-meanDP 40 --min-alleles 2 --max-alleles 2 --mac 2  --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${workdir}/05b_contamination_check/${region_array}__contamination_check

bgzip ${workdir}/05b_contamination_check/${region_array}__contamination_check.recode.vcf
tabix ${workdir}/05b_contamination_check/${region_array}__contamination_check.recode.vcf.gz
