#!/bin/bash

dataName=$1
dataPath=$2
dataType=$3
chempropenv=$4

source activate $chempropenv
python dump_time_folds.py --data_name $dataName --data_path $dataPath --dataset_type $dataType # time folds
cd ../chemprop
bash make_splits.sh $dataName $dataPath $dataType # random and scaffold folds
source deactivate