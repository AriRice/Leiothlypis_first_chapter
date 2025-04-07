#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=make_it_simple
#SBATCH --nodes=1 --ntasks=10
#SBATCH --partition nocona
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-401

source ~/anaconda3/etc/profile.d/conda.sh
conda activate phylostats_env

# Set the number of runs that each SLURM task should do
PER_TASK=53

# Calculate the starting and ending values for this task based
# on the SLURM task and the number of runs per task.
START_NUM=$(( ($SLURM_ARRAY_TASK_ID - 1) * $PER_TASK + 1 ))
END_NUM=$(( $SLURM_ARRAY_TASK_ID * $PER_TASK ))

# Print the task and run range
echo This is task $SLURM_ARRAY_TASK_ID, which will do runs $START_NUM to $END_NUM

# Run the loop of runs for this task.
for (( run=$START_NUM; run<=$END_NUM; run++ )); do
        echo This is SLURM task $SLURM_ARRAY_TASK_ID, run number $run

        chrom_array=$( head -n${run} tree_helper_chrom.txt | tail -n1 )

        start_array=$( head -n${run} tree_helper_start.txt | tail -n1 )

        end_array=$( head -n${run} tree_helper_end.txt | tail -n1 )

        gunzip -cd /lustre/scratch/arrice/Ch1_Leiothlypis/11_ABBA_BABA/CM019928.1__ABBA_BABA.recode.vcf.gz | grep "#" > /lustre/scratch/arrice/Ch1_Leiothlypis/11_ABBA_BABA/fd_vs_D/windows/${chrom_array}__${start_array}__${end_array}.recode.vcf

        tabix /lustre/scratch/arrice/Ch1_Leiothlypis/11_ABBA_BABA/${chrom_array}__ABBA_BABA.recode.vcf.gz ${chrom_array}:${start_array}-${end_array} >> /lustre/scratch/arrice/Ch1_Leiothlypis/11_ABBA_BABA/fd_vs_D/windows/${chrom_array}__${start_array}__${end_array}.recode.vcf

        bcftools query -f '%POS\t%REF\t%ALT[\t%GT]\n' /lustre/scratch/arrice/Ch1_Leiothlypis/11_ABBA_BABA/fd_vs_D/windows/${chrom_array}__${start_array}__${end_array}.recode.vcf > /lustre/scratch/arrice/Ch1_Leiothlypis/11_ABBA_BABA/fd_vs_D/windows/${chrom_array}__${start_array}__${end_array}.simple.vcf

        rm /lustre/scratch/arrice/Ch1_Leiothlypis/11_ABBA_BABA/fd_vs_D/windows/${chrom_array}__${start_array}__${end_array}.recode.vcf

done
