#!/bin/bash

gpu=$1

source main.sh bbbp ../data/bbbp/bbbp.csv classification auc 128 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 10 3 false true 300 300
source main.sh qm7 ../data/qm7/qm7.csv regression mae 256 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 10 3 false true 300 300
source main.sh pdbbind_refined ../data/pdbbind_refined/pdbbind_refined.csv regression rmse 128 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 10 3 false true 300 300
source main.sh pdbbind_core ../data/pdbbind_core/pdbbind_core.csv regression rmse 8 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 10 3 false true 300 300