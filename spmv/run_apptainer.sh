#!/bin/bash
#SBATCH --job-name=spmv
#SBATCH --output=logs/run_apptainer_%j.out
#SBATCH --time=00:10:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G

set -euo pipefail

APPTAINER_LOC=/d/hpc/projects/FRI/GEM5/gem5_workspace
APPTAINER_IMG=$APPTAINER_LOC/gcn-gpu_v24-0.sif
GEM5_ROOT=$APPTAINER_LOC/gem5
GEM5_PATH=$GEM5_ROOT/build/VEGA_X86


CU=8
KERNEL=histogram_opt

 srun --ntasks=1 --output=logs/cu${CU}.out \
    apptainer exec "$APPTAINER_IMG" \
    "$GEM5_PATH/gem5.opt" --outdir=stats/cu${CU} \
    "$GEM5_ROOT/configs/example/apu_se.py" \
    -n 3 --num-compute-units "$CU" --gfx-version="gfx902" \
    -c bin/spmv.bin