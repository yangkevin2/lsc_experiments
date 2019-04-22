#!/bin/bash

dataName=$1
dataPath=$2
dataType=$3
chempropenv=$4

source activate $chempropenv
python dump_time_folds.py --data_name $dataName --data_path $dataPath --dataset_type $dataType # time folds
cd ../chemprop/scripts
python create_crossval_indices.py --data_path $dataPath --save_dir ../../data/$dataName --split_type random --num_folds 10 --test_folds_to_test 3
python create_crossval_indices.py --data_path $dataPath --save_dir ../../data/$dataName --split_type scaffold --num_folds 10 --test_folds_to_test 3
cd ..
source deactivate
# cd ../chemprop
# bash make_splits.sh $dataName $dataPath $dataType # random and scaffold folds
# source deactivate