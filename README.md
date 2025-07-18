# hpc-sleap
automating pose estimation training and inference on high performance computing platforms

## to-do

- [ ] script to secure copy all files
- [ ] script to store user information for hpc
- [ ] test on slurm
- [ ] steps for model training

## Grid Engine 
This is currently working on UCL's Myriad high performance computing cluster.

### sleap installation
First, load the necessary modules
```commandline
module -f unload compilers mpi gcc-libs
module load beta-modules
module load gcc-libs/10.2.0
module load python/3.9.6-gnu-10.2.0 # use python3 to access
module load cuda/11.2.0/gnu-10.2.0
module load cudnn/8.1.0.77/cuda-11.2
module load tensorflow/2.11.0/gpu
```
Second, create a virtual environment for sleap
```commandline 
virtualenv sleap
```
Third, install necessary packages
```commandline
source sleap/bin/activate
pip3 install sleap[pypi]==1.3.3
pip3 install -U PySide2
```
We can now test to see if sleap is installed
```commandline
python -c "import sleap; sleap.versions()"
```

### editing scripts
For the moment, you'll need to edit the job scripts as certain lines are hardcoded. Check the README.md in the ``grid_engine`` for details.

### setting path variables
To simplify running job scripts, it is best to set some path variables in your ``.bashrc``
```commandline
nano ~/.bashrc
```
At the end of the document you can set a path for the location of your video files:
```shell
video_dir=/path/to/videos/for/sleap
```
...and the path for any trained models
```shell
model_1=/path/to/models/model_1.instance
model_2=/path/to/models/model_2.instance
```
This will make it easier when submitting jobs as you can run:
```commandline
qsub sleapInferenceBatch.sh "$video_dir/batch_files.json" "$model_1"
```

## paramfiles for batch inference
To create a json param file for batch inference, use the 'create_param_file.py' script:
```commandline
python create_param_file.py 'file/directory' 'video_format'
```
