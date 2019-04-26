#!/bin/bash

gpu=$1

source main.sh ethylacetat ../data/ethylacetat/ethylacetat.csv regression r2 256 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 3 1 false true 300 300
source main.sh h2o ../data/h2o/h2o.csv regression r2 256 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 3 1 false true 300 300
source main.sh octanol ../data/octanol/octanol.csv regression r2 256 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 3 1 false true 300 300