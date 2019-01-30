#!/bin/bash

dataName=$1
dataPath=$2
dataType=$3
python2env=$4
python3env=$5

source activate $python2env
echo "pubchem features"
python pubchem.py --data_name $dataName --data_path $dataPath --dataset_type $dataType
source deactivate

source activate $python3env
echo "SHED and CATS2D features"
bash all_shed_cats2d.sh $dataName $dataPath $dataType
echo "rdkit and maccs features"
python rdkit_maccs.py --data_name $dataName --data_path $dataPath --dataset_type $dataType

echo "concatenating features"
bash all_combine.sh $dataName $dataPath $dataType
source deactivate