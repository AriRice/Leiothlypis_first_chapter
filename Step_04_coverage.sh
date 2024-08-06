#!/bin/bash
#SBATCH --chdir=./01_bam_files
#SBATCH --job-name=ca_depth
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=3
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL

source ~/anaconda3/etc/profile.d/conda.sh
conda activate samtools

samtools depth -a M1_luciae_1_final.bam M3_crissalis_1_final.bam M4_crissalis_2_final.bam M5_crissalis_3_final.bam \
M6_celata_1_final.bam M7_crissalis_4_final.bam M8_peregrina_1_final.bam M9_peregrina_2_final.bam \
M11_ruficapilla_1_final.bam M12_ruficapilla_2_final.bam M13_celata_2_final.bam M14_peregrina_4_final.bam M15_celata_3_final.bam \
M17_ruficapilla_4_final.bam M18_peregrina_5_final.bam M19_celata_4_final.bam M20_celata_5_final.bam \
M21_virginiae_1_final.bam M22_crissalis_5_final.bam M23_luciae_2_final.bam M24_luciae_3_final.bam M25_luciae_4_final.bam \
M26_virginiae_2_final.bam M27_virginiae_3_final.bam M28_virginiae_4_final.bam M29_virginiae_5_final.bam \
M30_luciae_5_final.bam G_poliocephala_KU25093_final.bam G_poliocephala_KU33403_final.bam \
G_poliocephala_KU33414_final.bam G_poliocephala_KU33542_final.bam \
G_poliocephala_KU9041_final.bam N16_peregrina_6_final.bam N17_peregrina_7_final.bam N18_ruficapilla_6_final.bam \
N19_ruficapilla_7_final.bam N20_ruficapilla_8_final.bam N21_ruficapilla_9_final.bam > leiothlypis_coverage.txt

# break up the depth files into single column files for each individual

while read -r name1 number1; do
        number2=$((number1 + 2));
  cut leiothlypis_coverage.txt -f $number2 > ${name1}_depth.txt;
done < popmap.txt

mv leiothlypis_coverage.txt ../01_coverage
mv *depth.txt ../01_coverage
