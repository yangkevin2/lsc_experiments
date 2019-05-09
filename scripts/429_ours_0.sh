#!/bin/bash

gpu=$1

# source main.sh freesolv ../data/freesolv/freesolv.csv regression rmse 8 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 10 3 false true 300 300
source main.sh bace ../data/bace/bace.csv classification auc 16 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 10 3 false true 300 300
source main.sh delaney ../data/delaney/delaney.csv regression rmse 16 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 10 3 false true 300 300
source main.sh pdbbind_full ../data/pdbbind_full/pdbbind_full.csv regression rmse 256 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 10 3 false true 300 300