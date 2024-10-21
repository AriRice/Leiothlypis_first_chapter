#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=gphocs_filter
#SBATCH --nodes=1 --ntasks=1
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-32
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL

module load intel/18.0.3.222 vcftools/0.1.16

# define main working directory
workdir=/lustre/scratch/arrice/Leiothlypis

# define input files from helper file during genotyping
input_array=$( head -n${SLURM_ARRAY_TASK_ID} vcf_list.txt | tail -n1 )

# filtering for G-PhoCS
vcftools --vcf ${workdir}/04_filtered_vcf/${input_array}.filtered.vcf --remove badsamples.txt --max-missing 0.75 --minGQ 20 --minDP 6 --max-meanDP 40 --max-alleles 2  --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${workdir}/G-PhoCS/vcfs_for_G-PhoCS/${input_array}__GPHOCS
bgzip ${workdir}/G-PhoCS/vcfs_for_G-PhoCS/${input_array}__GPHOCS.recode.vcf
tabix -p vcf ${workdir}/G-PhoCS/vcfs_for_G-PhoCS/${input_array}__GPHOCS.recode.vcf.gz
