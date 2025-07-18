#!/bin/bash -l

# Request 1 GPU
#$ -l gpu=1

# Request information on job
#$ -m beas

# Clock time
#$ -l h_rt=8:00:0

# Request memory
#$ -l mem=8G

# Request TMPDIR space
#$ -l tmpfs=10G

# Name of job
#$ -N sleapInference

# Activate environment
source /location/of/sleap/installation/bin/activate#

# Load modules
module load jq
module -f unload compilers mpi gcc-libs
module load beta-modules
module load gcc-libs/10.2.0
module load python/3.9.6-gnu-10.2.0 # use python3 to access
module load cuda/11.2.0/gnu-10.2.0
module load cudnn/8.1.0.77/cuda-11.2
module load tensorflow/2.11.0/gpu

# Create vars
paramFile=$1
modelPath=$2
# fileCount="`sed -n 1p $paramFile | awk '{print $1}'`"
fileCount_="`jq .count $paramFile`"
fileCount="`echo "$fileCount_" | tr -d '"'`"
prefix=${paramFile%/*}
prefix+="/"

# Create number of runs...I think this is ok since we won't request 100 jobs

# Set working dir
#$ -wd /location/of/workspace

# Change to TMPDIR
cd $TMPDIR

# Loop through files in param file
for ((i=0;i<$((fileCount));i++))
do 
	currFile_="`jq .files[${i}] $paramFile`"
	currFile="`echo "$currFile_" | tr -d '"'`"
	currFilePath="${prefix}${currFile}"
	sleap-track "$currFilePath" -m "$modelPath" --verbosity json > sleap_inference_out.txt	
done
# Tar-up
tar -zcvf $HOME/Scratch/workspace/sleap_inference_$JOB_ID.tar.gz $TMPDIR
