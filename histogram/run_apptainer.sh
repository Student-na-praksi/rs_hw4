#!/bin/bash
#SBATCH --job-name=histogram_runs
#SBATCH --output=logs/run_apptainer_%j.out
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G

set -euo pipefail

APPTAINER_LOC=/d/hpc/projects/FRI/GEM5/gem5_workspace
APPTAINER_IMG=$APPTAINER_LOC/gcn-gpu_v24-0.sif
GEM5_ROOT=$APPTAINER_LOC/gem5
GEM5_PATH=$GEM5_ROOT/build/VEGA_X86


CU=2
KERNEL=histogram_opt

 srun --ntasks=1 --output=logs/${KERNEL}_cu${CU}.out \
    apptainer exec "$APPTAINER_IMG" \
    "$GEM5_PATH/gem5.opt" --outdir=CU_stats/${KERNEL}_cu${CU} \
    "$GEM5_ROOT/configs/example/apu_se.py" \
    -n 3 --num-compute-units "$CU" --gfx-version="gfx902" \
    -c ./bin/${KERNEL}.bin


# FULL RUN SIMULATION
# for CU in 2 4 8; do
#   for KERNEL in histogram_opt histogram_naive; do
#     srun --ntasks=1 --time=00:30:00 --output=logs/${KERNEL}_cu${CU}.out \
#       apptainer exec "$APPTAINER_IMG" \
#       "$GEM5_PATH/gem5.opt" --outdir=CU_stats/${KERNEL}_cu${CU} \
#       "$GEM5_ROOT/configs/example/apu_se.py" \
#       -n 3 --num-compute-units "$CU" --gfx-version="gfx902" \
#       -c ./bin/${KERNEL}.bin
#   done
# done

# SHOW STADTS
# metrics_cpu=("waveLevelParallelism::samples" "vALUInsts" "vpc" "globalReads" "globalWrites" "ldsBankAccesses" "coalsrLineAddresses::total"); 
# FILE=./stats.txt; for metric in "${metrics_cpu[@]}"; do echo "-------------------------------"; grep -ri "$metric" "$FILE"; done