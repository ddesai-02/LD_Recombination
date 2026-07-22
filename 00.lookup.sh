#!/bin/bash
#SBATCH --account=def-shaferab
#SBATCH --mem=1G
#SBATCH --cpus-per-task=1
#SBATCH --time=1-23:59:00
./LDhat/complete -n 88 -rhomax 100 -n_pts 101 -theta 0.001
