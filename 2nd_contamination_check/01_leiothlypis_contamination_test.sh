#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=Ch1_Leiothlypis_contamination_test
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL

./checkHetsIndvVCF.sh contam_check_merged.vcf.gz
