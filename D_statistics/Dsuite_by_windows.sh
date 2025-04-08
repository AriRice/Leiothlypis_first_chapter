#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=dsuite_by_windows
#SBATCH --nodes=1 --ntasks=2
#SBATCH --partition nocona
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-401

workdir=/lustre/scratch/arrice/Ch1_Leiothlypis/11_ABBA_BABA
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

        zgrep "#" ${workdir}/CM019928.1__ABBA_BABA.recode.vcf.gz > ${workdir}/Dstats_by_windows/${chrom_array}__${start_array}__${end_array}.recode.vcf

        tabix ${workdir}/${chrom_array}__ABBA_BABA.recode.vcf.gz ${chrom_array}:${start_array}-${end_array} >> ${workdir}/Dstats_by_windows/${chrom_array}__${start_array}__${end_array}.recode.vcf

        ~/Dsuite/Build/Dsuite Dtrios -n ${chrom_array}__${start_array}__${end_array} -t species_tree.nwk ${workdir}/Dstats_by_windows/${chrom_array}__${start_array}__${end_array}.recode.vcf Leio_Sets.txt -o ${workdir}/Dstats_by_windows/Leio_Sets

        rm /lustre/scratch/arrice/Ch1_Leiothlypis/11_ABBA_BABA/Dstats_by_windows/${chrom_array}__${start_array}__${end_array}.recode.vcf

done
