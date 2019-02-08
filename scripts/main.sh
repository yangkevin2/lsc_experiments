#!/bin/bash

# USAGE: source main.sh dataName dataPath dataType metric batchSize python2env chempropenv tfenv
# or run each of the bash files individually.
# example: source main.sh freesolv ../data/freesolv/freesolv.csv regression rmse 16 py27_paper_experiments py36_paper_experiments py36_paper_experiments 0

# assumes data is ordered chronologically for a time split, has been deduplicated, and is in the format expected by the chemprop model.
# put data in a folder analogous to the freesolv example.  

dataName=$1 # e.g. freesolv
dataPath=$2 # e.g. ../data/freesolv/freesolv.csv
dataType=$3 # regression or classification

metric=$4 # e.g. rmse
batchSize=$5 # e.g. 16

python2env=$6 # python2 conda env with chemfp installed. Can use "pip install chemfp" if you're on linux. Seems to be hard to install on MacOS.
chempropenv=$7 # python3 conda env with chemprop requirements installed.
tfenv=$8 # python3 conda env with tensorflow. 

gpu=$9

echo "dump features pickle files and splits"
bash generate_all_features.sh $dataName $dataPath $dataType $python2env $chempropenv
source create_splits.sh $dataName $dataPath $dataType $chempropenv

echo "run model" # defaults to using gpu0. See run_model.sh if you want to change the gpu. 
cd ../lsc/pythonCode/apred
bash run_model.sh $dataName $dataType $metric $batchSize $tfenv $gpu

echo "write output"
source activate $chempropenv
cd ../../../scripts
python compile_lsc_results.py
source deactivate
