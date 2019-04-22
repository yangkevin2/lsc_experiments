#!/bin/bash

# source main3.sh ethanol ../../solvent_datasets/ethanol/ethanol.csv regression 1 20 1 &

cd ../chemprop

CUDA_VISIBLE_DEVICES=2 python train.py --metric r2 --data_path ../../solvent_datasets/ethanol/ethanol.csv --dataset_type regression --num_folds 1 --seed 10 --save_dir ../ckpt/ethanol_mpn_optimized_features_ensemble_scaffold/fold_7_new --quiet --split_type scaffold_balanced --config_path ../ckpt/ethanol_hyper.json --features_path "../features/rdkit_2d_normalized/ethanol.pckl" --no_features_scaling --ensemble_size 5 &
CUDA_VISIBLE_DEVICES=2 python train.py --metric r2 --data_path ../../solvent_datasets/ethanol/ethanol.csv --dataset_type regression --num_folds 1 --seed 11 --save_dir ../ckpt/ethanol_mpn_optimized_features_ensemble_scaffold/fold_8_new --quiet --split_type scaffold_balanced --config_path ../ckpt/ethanol_hyper.json --features_path "../features/rdkit_2d_normalized/ethanol.pckl" --no_features_scaling --ensemble_size 5 &
CUDA_VISIBLE_DEVICES=3 python train.py --metric r2 --data_path ../../solvent_datasets/ethanol/ethanol.csv --dataset_type regression --num_folds 1 --seed 12 --save_dir ../ckpt/ethanol_mpn_optimized_features_ensemble_scaffold/fold_9_new --quiet --split_type scaffold_balanced --config_path ../ckpt/ethanol_hyper.json --features_path "../features/rdkit_2d_normalized/ethanol.pckl" --no_features_scaling --ensemble_size 5 &

echo "ethanol done"

wait