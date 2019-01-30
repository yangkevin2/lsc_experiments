#!/bin/bash

dataName=$1
dataPath=$2
dataType=$3

python extract_smiles.py --data_name $dataName --data_path $dataPath --dataset_type $dataType
bash shed_cats2d.sh $dataName
python process_shed_cats2d.py --data_name $dataName --data_path $dataPath --dataset_type $dataType