#!/bin/bash

gpu=$1

source main3.sh benzene ../../solvent_datasets/benzene/benzene.csv regression 1 20 $gpu
source main3.sh cyclohexan ../../solvent_datasets/cyclohexan/cyclohexan.csv regression 1 20 $gpu
source main3.sh dichlormethan ../../solvent_datasets/dichlormethan/dichlormethan.csv regression 1 20 $gpu