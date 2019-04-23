#!/bin/bash

dataName=$1
dataPath=$2
dataType=$3
chempropenv=$4
test_folds_to_test=$5
val_folds_per_test=$6

source activate $chempropenv
python dump_time_folds.py --data_name $dataName --data_path $dataPath --dataset_type $dataType # time folds
cd ../chemprop/scripts
python create_crossval_indices.py --data_path ../../scripts/$dataPath --split_type random --num_folds 10 --test_folds_to_test $test_folds_to_test --val_folds_per_test $val_folds_per_test
python create_crossval_indices.py --data_path ../../scripts/$dataPath --split_type scaffold --num_folds 10 --test_folds_to_test $test_folds_to_test --val_folds_per_test $val_folds_per_test
cd ..
source deactivate
# cd ../chemprop
# bash make_splits.sh $dataName $dataPath $dataType # random and scaffold folds
# source deactivate