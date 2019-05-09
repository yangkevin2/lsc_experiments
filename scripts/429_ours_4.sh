#!/bin/bash

gpu=$1

# source main.sh lipo ../data/lipo/lipo.csv regression rmse 128 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 10 3 false true 300 300
source main.sh clintox ../data/clintox/clintox.csv classification auc 64 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 10 3 false true 300 300
source main.sh sider ../data/sider/sider.csv classification auc 64 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 10 3 false true 300 300
source main.sh tox21 ../data/tox21/tox21.csv classification auc 256 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 10 3 false true 300 300
source main.sh toxcast ../data/toxcast/toxcast.csv classification auc 256 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 10 3 false true 300 300
