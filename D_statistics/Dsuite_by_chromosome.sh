#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=ABBA-BABA
#SBATCH --nodes=1 --ntasks=2
#SBATCH --partition nocona
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-32
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL

workdir=/lustre/scratch/arrice/Ch1_Leiothlypis/11_ABBA_BABA
source ~/anaconda3/etc/profile.d/conda.sh
conda activate phylostats_env

chrom_array=$( head -n${SLURM_ARRAY_TASK_ID} ../scaffolds.txt | tail -n1 )

~/Dsuite/Build/Dsuite Dtrios -n ${chrom_array} -t species_tree.nwk ${chrom_array}__ABBA_BABA.recode.vcf.gz Leio_Sets.txt -o ${workdir}/Dstats_by_chromosome/Leio_Sets
