#!/bin/bash

#SBATCH --job-name=run
#SBATCH --partition=64c512g
#SBATCH -n 4
#SBATCH --ntasks-per-node=4
#SBATCH --output=%j.out
#SBATCH --error=%j.err

module load lammps
srun lmp < in.edge
