#!/bin/bash
#SBATCH --job-name=mat_transpose_runs
#SBATCH --output=logs/run_transpose_%j.out
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G

set -euo pipefail

APPTAINER_LOC=/d/hpc/projects/FRI/GEM5/gem5_workspace
APPTAINER_IMG=$APPTAINER_LOC/gcn-gpu_v24-0.sif
GEM5_ROOT=$APPTAINER_LOC/gem5

GEM5_PATH=$GEM5_ROOT/build/VEGA_X86
BENCH_BIN=./bin/mat_transpose.bin

for CU in 4 8 ; do
    srun --ntasks=1 --output="logs/mat_transpose_cu${CU}.out" \
        apptainer exec --bind "$PWD:$PWD" "$APPTAINER_IMG" \
        "$GEM5_PATH/gem5.opt" --outdir="CU_stats/mat_transpose_cu${CU}" \
        "$GEM5_ROOT/configs/example/apu_se.py" \
        --benchmark-root "$PWD" -n 3 --num-compute-units "$CU" --gfx-version="gfx902" \
        -c "$BENCH_BIN"
done