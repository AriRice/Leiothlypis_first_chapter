#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=Hurry_the_f_up_already
#SBATCH --nodes=10 --ntasks=1
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL

### This is with 500 kbp removed from the flanking regions of exons. If we want more stringent filtering, do previous steps to make these two bed files
### (1kbp_loci.bed and kept_regions_1kbp.bed) with the final_exons_1kbpflank.bed file. That's twice as much flanking material removed (1000 bp instead of 500 on each side).

module load intel/18.0.3.222 bedtools/2.27.1

bedtools intersect -a ./vcfs_for_G-PhoCS/GPHOCS_merged.vcf.gz -b 1kbp_loci.bed -g genome_file > smallest_whole_genome.vcf 
gzip smallest_whole_genome.vcf

bedtools intersect -a ./vcfs_for_G-PhoCS/GPHOCS_merged.vcf.gz -b kept_regions_1kbp.bed -g genome_file > smaller_whole_genome.vcf 
gzip smaller_whole_genome.vcf
