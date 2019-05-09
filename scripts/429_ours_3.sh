#!/bin/bash

gpu=$1

source main_big.sh pcba ../data/pcba/pcba.csv classification prc-auc 512 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 3 1 false false 300 300