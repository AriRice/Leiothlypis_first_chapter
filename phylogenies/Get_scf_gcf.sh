#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=Get_SCFs_and_GCFs
#SBATCH --partition nocona
#SBATCH --nodes=1 --ntasks=35
#SBATCH --time=48:00:00
#SBATCH --mem=100G
#SBATCH --mail-user=arrice@ttu.edu
#SBATCH --mail-type=ALL

source ~/anaconda3/etc/profile.d/conda.sh
conda activate iqtree

iqtree -t leiothlypis_50kbp.nwk --gcf Leiothlypis_50kbp.trees -s Concat_Leio_pasta.fasta --scf 100 --prefix SCF_GCF_concord -T 30
