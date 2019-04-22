#!/bin/bash

# gpu=$1

# source main3.sh h2o ../../solvent_datasets/h2o/h2o.csv regression 1 20 $gpu
# source main3.sh octanol ../../solvent_datasets/octanol/octanol.csv regression 1 20 $gpu
# source main3.sh thf ../../solvent_datasets/thf/thf.csv regression 1 20 $gpu
# source main3.sh toluol ../../solvent_datasets/toluol/toluol.csv regression 1 20 $gpu

source main3.sh cyclohexan ../../solvent_datasets/cyclohexan/cyclohexan.csv regression 1 20 0
source main3.sh thf ../../solvent_datasets/thf/thf.csv regression 1 20 0