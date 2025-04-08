#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=D_and_fD
#SBATCH --nodes=1 --ntasks=1
#SBATCH --partition nocona
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-401

workdir=/lustre/scratch/arrice/Ch1_Leiothlypis/11_ABBA_BABA/fd_vs_D
source ~/anaconda3/etc/profile.d/conda.sh
conda activate phylostats_env

# Set the number of runs that each SLURM task should do
PER_TASK=53

# Calculate the starting and ending values for this task based
# on the SLURM task and the number of runs per task.
START_NUM=$(( ($SLURM_ARRAY_TASK_ID - 1) * $PER_TASK + 1 ))
END_NUM=$(( $SLURM_ARRAY_TASK_ID * $PER_TASK ))

echo This is task $SLURM_ARRAY_TASK_ID, which will do runs $START_NUM to $END_NUM

R --no-save

# Run the loop of runs for this task.
for (( run=$START_NUM; run<=END_NUM; run++ )); do
        echo This is SLURM task $SLURM_ARRAY_TASK_ID, run number $run

        input_array=$( head -n${run} window_list.txt | tail -n1 )

        Rscript D_and_fD_stats_v2.r ${workdir}/windows/${input_array} leio_introgression_popmap.txt leio_introgression_comparisons.txt

done
