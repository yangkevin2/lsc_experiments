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

test_folds_to_test=${10}
val_folds_per_test=${11}
time_split=${12}
run_features=${13}
num_epochs=${14}

echo "dump features pickle files and splits"
if [ "$run_features" == "true" ]
then
    bash generate_all_features.sh $dataName $dataPath $dataType $python2env $chempropenv
fi
source create_splits2.sh $dataName $dataPath $dataType $chempropenv $test_folds_to_test $val_folds_per_test $time_split

echo "run model" # defaults to using gpu0. See run_model2.sh if you want to change the gpu. 
cd ../lsc/pythonCode/apred
bash run_model2.sh $dataName $dataType $metric $batchSize $tfenv $gpu $test_folds_to_test $val_folds_per_test $time_split $num_epochs $num_epochs

echo "write output"
source activate $chempropenv
cd ../../../scripts
python compile_lsc_results.py --num_test_folds $test_folds_to_test
source deactivate
