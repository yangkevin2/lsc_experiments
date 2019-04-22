#!/bin/bash

# gpu=$1

# source main3.sh h2o ../../solvent_datasets/h2o/h2o.csv regression 1 20 $gpu
# source main3.sh octanol ../../solvent_datasets/octanol/octanol.csv regression 1 20 $gpu
# source main3.sh thf ../../solvent_datasets/thf/thf.csv regression 1 20 $gpu
# source main3.sh toluol ../../solvent_datasets/toluol/toluol.csv regression 1 20 $gpu

source main3.sh h2o ../../solvent_datasets/h2o/h2o.csv regression 1 20 2
source main3.sh ethanol ../../solvent_datasets/ethanol/ethanol.csv regression 1 20 2