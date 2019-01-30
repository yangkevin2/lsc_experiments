#!/bin/bash

dataName=$1
dataPath=$2
dataType=$3

python combine_semif.py --data_name $dataName --data_path $dataPath --dataset_type $dataType
python format_lsc.py --data_name $dataName --data_path $dataPath --dataset_type $dataType