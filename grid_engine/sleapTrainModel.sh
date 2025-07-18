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
#$ -N sleapTrainModel

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
modelPath=$1
paramFile="${modelPath}/jobs.json"
sleapPkg="`jq .training[0].train_labels ${paramFile}`"
sleapInstance="`jq .training[0].cfg ${paramFile}`"

slpPkg=$(echo "$sleapPkg" | tr -d '"')
slpInstance=$(echo "$sleapInstance" | tr -d '"')

slpInstancePath="${modelPath}/${slpInstance}"
slpPkgPath="${modelPath}/${slpPkg}"


# Set working dir
#$ -wd #/location/of/workspace

# Change to TMPDIR
cd $TMPDIR

# File all need to be loaded to Scratch
sleap-train "$slpInstancePath" "$slpPkgPath" > sleap_out.txt

# Tar-up
tar -zcvf $HOME/Scratch/workspace/sleap_train_$JOB_ID.tar.gz $TMPDIR
