#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=D_and_fD_chrom
#SBATCH --nodes=1 --ntasks=1
#SBATCH --partition nocona
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-32

source ~/anaconda3/etc/profile.d/conda.sh
conda activate phylostats_env

R --no-save

input_array=$( head -n${SLURM_ARRAY_TASK_ID} ../scaffolds.txt | tail -n1 )

Rscript Chrom_level_D_and_fD_stats.r ${input_array}__ABBA_BABA.simple.vcf ../leio_introgression_popmap.txt ../leio_introgression_comparisons.txt
