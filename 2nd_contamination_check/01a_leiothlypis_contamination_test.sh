#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=Ch1_Leiothlypis_contamination_test_1a
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL

module load intel R

Rscript contamination_check.R dataset3.contamination.test.vcf.gz 23621 100

# Insert numbers like these at the end of the line, but instead use  whatever the first test script spits out
# 8180 100  
