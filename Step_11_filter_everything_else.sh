#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=Ch1_filter_everything_else
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

# filtering for phylogenies, dxy, Heterozygosity, and Fst
vcftools --vcf ${workdir}/04_filtered_vcf/${region_array}.vcf --remove excluded_samples.txt --max-missing 0.9 --minGQ 20 --minDP 6 --max-meanDP 40 --max-alleles 2  --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${workdir}/06_phylogenies_and_summstats/${region_array}__phylostats

# filtering for TreeMix- thinned
vcftools --vcf ${workdir}/04_filtered_vcf/${region_array}.vcf --remove excluded_samples.txt --max-missing 1 --minGQ 20 --minDP 6 --max-meanDP 40 --min-alleles 2 --max-alleles 2 --mac 2 --thin 50000 --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${workdir}/07_TreeMix/${region_array}__Treemix_50kbpthin

# filtering for TreeMix- not thinned
vcftools --vcf ${workdir}/04_filtered_vcf/${region_array}.vcf --remove excluded_samples.txt --max-missing 1 --minGQ 20 --minDP 6 --max-meanDP 40 --min-alleles 2 --max-alleles 2 --mac 2  --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${workdir}/07_TreeMix/${region_array}__Treemix_nothin

# filtering for ABBA_BABA
vcftools --vcf ${workdir}/04_filtered_vcf/${region_array}.vcf --remove excluded_samples.txt --max-missing 0.6 --minGQ 20 --minDP 6 --max-meanDP 40 --min-alleles 2 --max-alleles 2 --mac 2 --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${workdir}/11_ABBA_BABA/${region_array}__ABBA_BABA


# bgzip and tabix index files that will be subdivided into windows
# directory 1
bgzip ${workdir}/06_phylogenies_and_summstats/${region_array}__phylostats.recode.vcf
bgzip ${workdir}/07_TreeMix/${region_array}__Treemix_Nothin.recode.vcf
bgzip ${workdir}/07_TreeMix/${region_array}__Treemix_50kbpthin.recode.vcf
bgzip ${workdir}/11_ABBA_BABA/${region_array}__ABBA_BABA.recode.vcf

#tabix
tabix -p vcf ${workdir}/06_phylogenies_and_summstats/${region_array}__phylostats.recode.vcf.gz
tabix -p vcf ${workdir}/07_TreeMix/${region_array}__Treemix_Nothin.recode.vcf.gz
tabix -p vcf ${workdir}/07_TreeMix/${region_array}__Treemix_50kbpthin.recode.vcf.gz
tabix -p vcf ${workdir}/11_ABBA_BABA/${region_array}__ABBA_BABA.recode.vcf.gz
