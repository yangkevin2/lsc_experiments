#!/bin/bash

gpu=$1

source main.sh muv ../data/muv/muv.csv classification prc-auc 256 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 3 1 false false 300 300