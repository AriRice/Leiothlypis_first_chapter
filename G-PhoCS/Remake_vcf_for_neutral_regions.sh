#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=remake_neutral_regions_vcf
#SBATCH --nodes=1 --ntasks=1
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL

module load intel/18.0.3.222 vcftools/0.1.16
vcftools --gzvcf GPHOCS_merged.vcf.gz --bed Thinning_output.bed --remove ones_we_dont_need.txt --max-missing 0.86 --out neutral_regions_v2 --recode --keep-INFO-all

bgzip neutral_regions_v2.recode.vcf
