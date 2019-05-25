#!/bin/bash

# USAGE: source main2.sh dataName dataPath dataType numGpus numHyperIters chempropenv gpu
# example: source main2.sh freesolv ../data/freesolv/freesolv.csv regression 1 20 py36_paper_experiments

# assumes data is ordered chronologically for a time split, has been deduplicated, and is in the format expected by the chemprop model.
# put data in a folder analogous to the freesolv example.

dataName=$1 # e.g. freesolv
dataPath=$2 # e.g. ../data/freesolv/freesolv.csv
dataType=$3 # regression or classification
numGpus=$4 # number of available gpus
numHyperIters=$5 # number of hyperparameter sets to try
chempropenv=$6 # python3 conda env with chemprop requirements installed.
num_test_folds=$7 # 3
val_folds_per_test=$8 # 1
metric=$9 # rmse
time_split=${10} # true

gpu=${11} # gpu num to run on
singletask=${12}

featuresPath="../features/rdkit_2d_normalized/${dataName}"
featuresMorganPath="../features/morgan/${dataName}"
featuresMorganCountPath="../features/morgan_count/${dataName}"

# source create_splits2.sh $dataName $dataPath $dataType $chempropenv $num_test_folds $val_folds_per_test $time_split

source activate $chempropenv

echo "Generating RDKit Features"
cd ../clean/chemprop/scripts
python save_features.py --data_path ../../$dataPath --features_generator rdkit_2d_normalized --save_path ../${featuresPath}.npz --restart --sequential
python save_features.py --data_path ../../$dataPath --features_generator morgan --save_path ../${featuresMorganPath}.npz --restart --sequential
python save_features.py --data_path ../../$dataPath --features_generator morgan_count --save_path ../${featuresMorganCountPath}.npz --restart --sequential
cd ..

if [ "$singletask" == "true" ]
then
    st="--single_task"
else
    st=""
fi

echo "Baselines"

echo "Random Forest"
echo "Random"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    python random_forest.py --data_path ../$dataPath --dataset_type $dataType --quiet --metric $metric --save_dir ../ckpt/${dataName}_randomforest_random_$i --split_type predetermined --folds_file ../../data/${dataName}/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 $st
done
wait
echo "Scaffold"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    python random_forest.py --data_path ../$dataPath --dataset_type $dataType --quiet --metric $metric --save_dir ../ckpt/${dataName}_randomforest_scaffold_$i --split_type predetermined --folds_file ../../data/${dataName}/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 $st
done
wait
if [ "$time_split" == "true" ]
then
echo "Time Window"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    python random_forest.py --data_path ../$dataPath --dataset_type $dataType --quiet --metric $metric --save_dir ../ckpt/${dataName}_randomforest_time_window/random_$i --split_type predetermined --folds_file ../../data/${dataName}/time_window/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 $st
    python random_forest.py --data_path ../$dataPath --dataset_type $dataType --quiet --metric $metric --save_dir ../ckpt/${dataName}_randomforest_time_window/scaffold_$i --split_type predetermined --folds_file ../../data/${dataName}/time_window/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 $st
    python random_forest.py --data_path ../$dataPath --dataset_type $dataType --quiet --metric $metric --save_dir ../ckpt/${dataName}_randomforest_time_window/time_$i --split_type predetermined --folds_file ../../data/${dataName}/time_window/time/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 $st
done
echo "Time"
#gpu=$((($gpu + 1) % $numGpus))
python random_forest.py --num_folds $num_test_folds --data_path ../$dataPath --dataset_type $dataType --quiet --metric $metric --save_dir ../ckpt/${dataName}_randomforest_time --split_type predetermined --folds_file ../../data/${dataName}/time/fold_0/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 $st
wait
fi

cd ../ckpt

python ../../scripts/compile_main2results.py

cd ../../scripts

source deactivate
