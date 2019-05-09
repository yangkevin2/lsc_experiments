#!/bin/bash

gpu=$1

source main.sh hiv ../data/hiv/hiv.csv classification auc 512 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 10 3 false false 300 300