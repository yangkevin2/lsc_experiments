#!/bin/bash

gpu=$1

# dataName=$1 # e.g. freesolv
# dataPath=$2 # e.g. ../data/freesolv/freesolv.csv
# dataType=$3 # regression or classification
# numGpus=$4 # number of available gpus
# numHyperIters=$5 # number of hyperparameter sets to try
# chempropenv=$6 # python3 conda env with chemprop requirements installed.
# num_test_folds=$7
# val_folds_per_test=$8
# metric=$9
# time_split=${10}

# gpu=${1ethylacetat
# source main2.sh cyclohexan ../data/cyclohexan/cyclohexan.csv regression 1 20 py36_paper_experiments 3 1 r2 false $gpu &
# source main2.sh dichlormethan ../data/dichlormethan/dichlormethan.csv regression 1 20 py36_paper_experiments 3 1 r2 false $gpu &
# wait
source main2.sh benzene ../data/benzene/benzene.csv regression 1 20 py36_paper_experiments 3 1 r2 false $gpu &
source main2.sh ethylacetat ../data/ethylacetat/ethylacetat.csv regression 1 20 py36_paper_experiments 3 1 r2 false $gpu & 
wait