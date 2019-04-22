#!/bin/bash

gpu=$1

source main.sh h2o ../../solvent_datasets/h2o/h2o.csv regression r2 128 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu
source main.sh octanol ../../solvent_datasets/octanol/octanol.csv regression r2 128 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu
source main.sh thf ../../solvent_datasets/thf/thf.csv regression r2 128 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu
source main.sh toluol ../../solvent_datasets/toluol/toluol.csv regression r2 128 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu