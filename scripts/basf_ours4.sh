#!/bin/bash

# gpu=$1

source main3.sh dichlormethan ../../solvent_datasets/dichlormethan/dichlormethan.csv regression 1 20 2 &
source main3.sh ethylacetat ../../solvent_datasets/ethylacetat/ethylacetat.csv regression 1 20 1 &

echo "complete0"

wait

source main3.sh benzene ../../solvent_datasets/benzene/benzene.csv regression 1 20 2 &
source main3.sh dmso ../../solvent_datasets/dmso/dmso.csv regression 1 20 1 &

echo "complete1"

wait

source main3.sh octanol ../../solvent_datasets/octanol/octanol.csv regression 1 20 2 &
source main3.sh toluol ../../solvent_datasets/toluol/toluol.csv regression 1 20 1 &

echo "complete2"

wait

source main3.sh h2o ../../solvent_datasets/h2o/h2o.csv regression 1 20 2 &
source main3.sh ethanol ../../solvent_datasets/ethanol/ethanol.csv regression 1 20 1 &

echo "complete2"

wait

source main3.sh cyclohexan ../../solvent_datasets/cyclohexan/cyclohexan.csv regression 1 20 2 &
source main3.sh thf ../../solvent_datasets/thf/thf.csv regression 1 20 1 &

echo "complete_all"

wait