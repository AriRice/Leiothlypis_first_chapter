#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=POOPING_TIME
#SBATCH --nodes=1 --ntasks=1
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL

module load intel/18.0.3.222 vcftools/0.1.16

vcf-concat *.vcf.gz  | gzip -c > GPHOCS_merged.vcf.gz
