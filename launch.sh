#!/bin/bash

export BENCHMARK=nccl-test
export DATADIR=/raid/datasets/wmt16_de_en

# Num experiments
export NEXP=1
export DGXSYSTEM=${1:-"DGX1_multi"}
export CONT=gitlab-master.nvidia.com/dl/dgx/pytorch:19.06-py3-devel
export DATESTAMP=`date +'%Y%m%d%H%M%S'`
export CMD=${2:-"all_reduce_perf -b8M -e128M -f2 -n100 -w10 -c0"}

source config_$DGXSYSTEM.sh

set -x
sbatch -p mlperf \
	-N $DGXNNODES \
    -t 4:00:00 \
    -J $BENCHMARK \
	--exclusive \
    --mem=0 \
	--mail-type=FAIL \
	--ntasks-per-node=1 \
	--threads-per-core=$DGXHT \
	--cores-per-socket=$DGXSOCKETCORES \
	run.sub 
set +x

