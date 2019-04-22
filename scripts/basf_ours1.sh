#!/bin/bash

gpu=$1

# source main3.sh dmso ../../solvent_datasets/dmso/dmso.csv regression 1 20 $gpu
source main3.sh ethanol ../../solvent_datasets/ethanol/ethanol.csv regression 1 20 $gpu
source main3.sh ethylacetat ../../solvent_datasets/ethylacetat/ethylacetat.csv regression 1 20 $gpu