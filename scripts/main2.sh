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
num_test_folds=$7
val_folds_per_test=$8
metric=$9
time_split=${10}

gpu=3

featuresPath="../features/rdkit_2d_normalized/${dataName}"
featuresMorganPath="../features/morgan/${dataName}"
featuresMorganCountPath="../features/morgan_count/${dataName}"

# source create_splits2.sh $dataName $dataPath $dataType $chempropenv $num_test_folds $val_folds_per_test $time_split

source activate $chempropenv

echo "Generating RDKit Features"
cd ../clean/chemprop/scripts
python save_features.py --data_path $dataPath --features_generator rdkit_2d_normalized --save_path ../${featuresPath}.npz --restart
python save_features.py --data_path $dataPath --features_generator morgan --save_path ../${featuresMorganPath}.npz --restart
python save_features.py --data_path $dataPath --features_generator morgan_count --save_path ../${featuresMorganCountPath}.npz --restart
cd ..

echo "Baselines"

echo "FFN on Morgan"
echo "Random"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresMorganPath}.npz --save_dir ../ckpt/${dataName}_morgan_random_$i --quiet --split_type predetermined  --folds_file ../../data/${dataName}/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
done
wait
echo "Scaffold"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresMorganPath}.npz --save_dir ../ckpt/${dataName}_morgan_scaffold_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
done
wait
if [ "$time_split" == "true" ]
then
echo "Time Window"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresMorganPath}.npz --save_dir ../ckpt/${dataName}_morgan_time_window/random_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresMorganPath}.npz --save_dir ../ckpt/${dataName}_morgan_time_window/scaffold_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresMorganPath}.npz --save_dir ../ckpt/${dataName}_morgan_time_window/time_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/time/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
done
echo "Time"
#gpu=$((($gpu + 1) % $numGpus))
CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresMorganPath}.npz --num_folds 10 --seed 3 --save_dir ../ckpt/${dataName}_morgan_time --quiet --split_type predetermined --folds_file ../../data/${dataName}/time/fold_0/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
wait
fi

echo "FFN on Morgan counts"
echo "Random"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresMorganCountPath}.npz --save_dir ../ckpt/${dataName}_morgan_count_random_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
done
wait
echo "Scaffold"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresMorganCountPath}.npz --save_dir ../ckpt/${dataName}_morgan_count_scaffold_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
done
wait
if [ "$time_split" == "true" ]
then
echo "Time Window"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresMorganCountPath}.npz --save_dir ../ckpt/${dataName}_morgan_count_time_window/random_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresMorganCountPath}.npz --save_dir ../ckpt/${dataName}_morgan_count_time_window/scaffold_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresMorganCountPath}.npz --save_dir ../ckpt/${dataName}_morgan_count_time_window/time_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/time/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
done
echo "Time"
#gpu=$((($gpu + 1) % $numGpus))
CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresMorganCountPath}.npz --num_folds 10 --seed 3 --save_dir ../ckpt/${dataName}_morgan_count_time --quiet --split_type predetermined --folds_file ../../data/${dataName}/time/fold_0/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
wait
fi

echo "FFN on RDKit"
echo "Random"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresPath}.npz --no_features--seed 3 --save_dir ../ckpt/${dataName}_rdkit_random_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
done
wait
echo "Scaffold"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresPath}.npz --no_features--seed 3 --save_dir ../ckpt/${dataName}_rdkit_scaffold_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
done
wait
if [ "$time_split" == "true" ]
then
echo "Time Window"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresPath}.npz --no_features--seed 3 --save_dir ../ckpt/${dataName}_rdkit_time_window/random_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresPath}.npz --no_features--seed 3 --save_dir ../ckpt/${dataName}_rdkit_time_window/scaffold_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresPath}.npz --no_features--seed 3 --save_dir ../ckpt/${dataName}_rdkit_time_window/time_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/time/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
done
echo "Time"
#gpu=$((($gpu + 1) % $numGpus))
CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --features_only --features_path ${featuresPath}.npz --no_features_scaling --num_folds 10 --seed 3 --save_dir ../ckpt/${dataName}_rdkit_time --quiet --split_type predetermined --folds_file ../../data/${dataName}/time/fold_0/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
wait
fi

echo "Baselines complete"

echo "Our MPN"

echo "Default MPN"
echo "Random"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_random_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
done
wait
echo "Scaffold"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_scaffold_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
done
wait
if [ "$time_split" == "true" ]
then
echo "Time Window"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_time_window/random_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_time_window/scaffold_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_time_window/time_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/time/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
done
echo "Time"
#gpu=$((($gpu + 1) % $numGpus))
CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --num_folds 10 --seed 3 --save_dir ../ckpt/${dataName}_mpn_time --quiet  --split_type predetermined --folds_file ../../data/${dataName}/time/fold_0/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 &
wait
fi

echo "Default MPN + Features"
echo "Random"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_features_random_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --features_path ${featuresPath}.npz --no_features_scaling &
done
wait
echo "Scaffold"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_features_scaffold_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --features_path ${featuresPath}.npz --no_features_scaling &
done
wait
if [ "$time_split" == "true" ]
then
echo "Time Window"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_features_time_window/random_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --features_path ${featuresPath}.npz --no_features_scaling &
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_features_time_window/scaffold_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --features_path ${featuresPath}.npz --no_features_scaling &
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_features_time_window/time_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/time/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --features_path ${featuresPath}.npz --no_features_scaling &
done
echo "Time"
#gpu=$((($gpu + 1) % $numGpus))
CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --num_folds 10 --seed 3 --save_dir ../ckpt/${dataName}_mpn_features_time --quiet  --split_type predetermined --folds_file ../../data/${dataName}/time/fold_0/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --features_path ${featuresPath}.npz --no_features_scaling &
wait
fi


echo "Hyperparameter Optimization"
echo "Random"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python hyperparameter_optimization.py --data_path $dataPath --dataset_type $dataType --num_iters $numHyperIters --config_save_path ../ckpt/${dataName}_hyper/random/$i.json --quiet --split_type index_predetermined --crossval_index_file ../data/${dataName}/random/fold_$i/split_indices.pckl --features_path ${featuresPath}.npz --no_features_scaling --metric $metric &
done
wait
echo "Scaffold"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python hyperparameter_optimization.py --data_path $dataPath --dataset_type $dataType --num_iters $numHyperIters --config_save_path ../ckpt/${dataName}_hyper/scaffold/$i.json --quiet --split_type index_predetermined --crossval_index_file ../data/${dataName}/scaffold/fold_$i/split_indices.pckl --features_path ${featuresPath}.npz --no_features_scaling --metric $metric &
done
wait
if [ "$time_split" == "true" ]
then
echo "Time Window"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python hyperparameter_optimization.py --data_path $dataPath --dataset_type $dataType --num_iters $numHyperIters --config_save_path ../ckpt/${dataName}_hyper/time_window/random/$i.json --quiet --split_type index_predetermined --crossval_index_file ../data/${dataName}/time_window/random/fold_$i/split_indices.pckl --features_path ${featuresPath}.npz --no_features_scaling --metric $metric &
    CUDA_VISIBLE_DEVICES=$gpu python hyperparameter_optimization.py --data_path $dataPath --dataset_type $dataType --num_iters $numHyperIters --config_save_path ../ckpt/${dataName}_hyper/time_window/scaffold/$i.json --quiet --split_type index_predetermined --crossval_index_file ../data/${dataName}/time_window/scaffold/fold_$i/split_indices.pckl --features_path ${featuresPath}.npz --no_features_scaling --metric $metric &
    CUDA_VISIBLE_DEVICES=$gpu python hyperparameter_optimization.py --data_path $dataPath --dataset_type $dataType --num_iters $numHyperIters --config_save_path ../ckpt/${dataName}_hyper/time_window/time/$i.json --quiet --split_type index_predetermined --crossval_index_file ../data/${dataName}/time_window/time/fold_$i/split_indices.pckl --features_path ${featuresPath}.npz --no_features_scaling --metric $metric &
done
echo "Time"
#gpu=$((($gpu + 1) % $numGpus))
CUDA_VISIBLE_DEVICES=$gpu python hyperparameter_optimization.py --data_path $dataPath --dataset_type $dataType --num_iters $numHyperIters --config_save_path ../ckpt/${dataName}_hyper/time/0.json --quiet --split_type predetermined --folds_file ../../data/${dataName}/time/fold_0/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --features_path ${featuresPath}.npz --no_features_scaling --metric $metric &
wait
fi

echo "Default MPN and Hyperparameter Optimization complete"

# echo "Optimized MPN"
# echo "Random"
# #gpu=$((($gpu + 1) % $numGpus))
# for ((i=0;i<num_test_folds;i++)); do
#     CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_optimized_random_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper_$i.json &
# done
# wait
# echo "Scaffold"
# #gpu=$((($gpu + 1) % $numGpus))
# for ((i=0;i<num_test_folds;i++)); do
#     CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_optimized_scaffold_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper_$i.json &
# done
# echo "Time"
# #gpu=$((($gpu + 1) % $numGpus))
# CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --num_folds 10 --seed 3 --save_dir ../ckpt/${dataName}_mpn_optimized_time --quiet  --split_type predetermined --folds_file ../../data/${dataName}/time/fold_0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper_$i.json &
# wait

echo "Optimized + Features MPN"
echo "Random"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_optimized_features_random_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper/random/$i.json --features_path ${featuresPath}.npz --no_features_scaling &
done
wait
echo "Scaffold"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_optimized_features_scaffold_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper/scaffold/$i.json --features_path ${featuresPath}.npz --no_features_scaling &
done
wait
if [ "$time_split" == "true" ]
then
echo "Time Window"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_optimized_features_time_window/random_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper/time_window/random/$i.json --features_path ${featuresPath}.npz --no_features_scaling &
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_optimized_features_time_window/scaffold_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper/time_window/scaffold/$i.json --features_path ${featuresPath}.npz --no_features_scaling &
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_optimized_features_time_window/time_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/time/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper/time_window/time/$i.json --features_path ${featuresPath}.npz --no_features_scaling &
done
echo "Time"
#gpu=$((($gpu + 1) % $numGpus))
CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --num_folds 10 --seed 3 --save_dir ../ckpt/${dataName}_mpn_optimized_features_time --quiet  --split_type predetermined --folds_file ../../data/${dataName}/time/fold_0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper/time/0.json --features_path ${featuresPath}.npz --no_features_scaling &
wait
fi

# echo "Optimized + Ensemble MPN"
# echo "Random"
# #gpu=$((($gpu + 1) % $numGpus))
# for ((i=0;i<num_test_folds;i++)); do
#     CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_optimized_ensemble_random_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper_$i.json --ensemble_size 5 &
# done
# wait
# echo "Scaffold"
# #gpu=$((($gpu + 1) % $numGpus))
# for ((i=0;i<num_test_folds;i++)); do
#     CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_optimized_ensemble_scaffold_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper_$i.json --ensemble_size 5 &
# done
# echo "Time"
# #gpu=$((($gpu + 1) % $numGpus))
# CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --num_folds 10 --seed 3 --save_dir ../ckpt/${dataName}_mpn_optimized_ensemble_time --quiet  --split_type predetermined --folds_file ../../data/${dataName}/time/fold_0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper_$i.json --ensemble_size 5 &
# wait

echo "Optimized + Features + Ensemble MPN"
echo "Random"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_optimized_features_ensemble_random_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper/random/$i.json --features_path ${featuresPath}.npz --no_features_scaling --ensemble_size 5 &
done
wait
echo "Scaffold"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_optimized_features_ensemble_scaffold_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper/scaffold/$i.json --features_path ${featuresPath}.npz --no_features_scaling --ensemble_size 5 &
done
wait
if [ "$time_split" == "true" ]
then
echo "Time Window"
for ((i=0;i<num_test_folds;i++)); do
    #gpu=$((($gpu + 1) % $numGpus))
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_optimized_features_ensemble_time_window/random_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/random/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper/time_window/random/$i.json --features_path ${featuresPath}.npz --no_features_scaling --ensemble_size 5 &
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_optimized_features_ensemble_time_window/scaffold_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/scaffold/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper/time_window/scaffold/$i.json --features_path ${featuresPath}.npz --no_features_scaling --ensemble_size 5 &
    CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --save_dir ../ckpt/${dataName}_mpn_optimized_features_ensemble_time_window/time_$i --quiet --split_type predetermined --folds_file ../../data/${dataName}/time_window/time/fold_$i/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper/time_window/time/$i.json --features_path ${featuresPath}.npz --no_features_scaling --ensemble_size 5 &
done
# wait
echo "Time"
#gpu=$((($gpu + 1) % $numGpus))
CUDA_VISIBLE_DEVICES=$gpu python train.py --data_path $dataPath --dataset_type $dataType --num_folds 10 --seed 3 --save_dir ../ckpt/${dataName}_mpn_optimized_features_ensemble_time --quiet  --split_type predetermined --folds_file ../../data/${dataName}/time/fold_0/0/split_indices.pckl --val_fold_index 1 --test_fold_index 2 --config_path ../ckpt/${dataName}_hyper/time/0.json --features_path ${featuresPath}.npz --no_features_scaling --ensemble_size 5 &
wait
fi

echo "Optimized + Features + Ensemble MPN complete"

cd ../ckpt

python ../../scripts/compile_main2.py

cd ../../scripts

source deactivate
