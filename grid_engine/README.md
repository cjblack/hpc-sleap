# sleapInferenceBatch.sh
Script for batch running inference on many files

## before running
You'll need to edit the hardcoded lines in this script:
In line **22** chance the code to the location of your sleap installation:
```shell
# Activate environment
source /location/of/sleap/installation/bin/activate
```
In line **46** you'll need to change the location of the working directory, which should be your workspace
```shell
# Set working dir
#$ -wd /location/of/workspace
```

# sleapTrainModel.sh
Script for running training on model package from sleap

## before running
You'll need to edit the hardcoded lines in this script:
In line **22** chance the code to the location of your sleap installation:
```shell
# Activate environment
source /location/of/sleap/installation/bin/activate
```