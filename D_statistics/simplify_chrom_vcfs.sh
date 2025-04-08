#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=make_it_simple_chrom
#SBATCH --nodes=1 --ntasks=10
#SBATCH --partition nocona
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-32

workdir=/lustre/scratch/arrice/Ch1_Leiothlypis/11_ABBA_BABA/fd_vs_D

source ~/anaconda3/etc/profile.d/conda.sh
conda activate phylostats_env

chrom_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/scaffolds.txt | tail -n1 )

bcftools query -f '%POS\t%REF\t%ALT[\t%GT]\n' /lustre/scratch/arrice/Ch1_Leiothlypis/11_ABBA_BABA/${chrom_array}__ABBA_BABA.recode.vcf.gz > ${workdir}/chrom_level/${chrom_array}__ABBA_BABA.simple.vcf
