#!/bin/bash
#SBATCH --account=def-shaferab
#SBATCH --time=23:59:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --array=1-36
#SBATCH --job-name=rhomap_pb
#SBATCH --output=rhomap_%A_%a.out

# 1. Extract the specific scaffold name for this specific array task
SCAFFOLD=$(sed -n "${SLURM_ARRAY_TASK_ID}p" scaffolds.txt)
LOOKUP_TABLE="lk_n50_t0.001"

echo "Starting rhomap MCMC on scaffold: $SCAFFOLD"

# 2. Run rhomap with standard MCMC parameters
/home/devan/software/LDhat/rhomap -seq "WH_ld_${SCAFFOLD}.ldhat.sites" \
         -loc "./locs/${SCAFFOLD}.ldhat.locs" \
         -lk "$LOOKUP_TABLE" \
         -its 10000000 \
         -samp 2000 \
         -burn 100000 \
         -prefix "${SCAFFOLD}_out_"

echo "Finished scaffold: $SCAFFOLD"
