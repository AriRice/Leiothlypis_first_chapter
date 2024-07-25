#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=Ch1_filter_admixture_pca
#SBATCH --nodes=1 --ntasks=1
#SBATCH --partition nocona
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-32
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL

conda activate vcftools

# define main working directory
workdir=/lustre/scratch/arrice/Ch1_Leiothlypis

# define input files from helper file during genotyping
region_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/scaffolds.txt | tail -n1 )

# filtering for admixture analyses and PCA- thinned
vcftools --vcf ${workdir}/04_filtered_vcf/${region_array}.vcf --remove outgroup.txt --max-missing 1 --minGQ 20 --minDP 6 --max-meanDP 40 --min-alleles 2 --max-alleles 2 --mac 2 --thin 50000 --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${workdir}/05_admixture_and_pca/${region_array}__structure_50kbpthin

# filtering for admixture analyses and PCA- not thinned
vcftools --vcf ${workdir}/04_filtered_vcf/${region_array}.vcf --remove outgroup.txt --max-missing 1 --minGQ 20 --minDP 6 --max-meanDP 40 --min-alleles 2 --max-alleles 2 --mac 2  --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${workdir}/05_admixture_and_pca/${region_array}__structure_nothin

bgzip ${workdir}/05_admixture_and_pca/${region_array}__structure_nothin.recode.vcf
bgzip ${workdir}/05_admixture_and_pca/${region_array}__structure_50kbpthin.recode.vcf

#tabix
tabix ${workdir}/05_admixture_and_pca/${region_array}__structure_nothin.recode.vcf.gz
tabix ${workdir}/05_admixture_and_pca/${region_array}__structure_50kbpthin.recode.vcf.gz
