#!/bin/bash

gpu=$1

source main2.sh rPPB_filter ../data/rPPB_filter/rPPB_filter_avg_dups.csv regression 1 20 chem3 10 3 rmse true $gpu &

# source main.sh RLM ../data/RLM/RLM_avg_dups.csv regression rmse 256 py27 chem3 tensorflow_p36 $gpu 1 1 true true 300 300
source main2.sh RLM ../data/RLM/RLM_avg_dups.csv regression 1 20 chem3 1 1 rmse true $gpu &

# source main.sh Sol ../data/Sol/Sol_avg_dups.csv regression rmse 256 py27 chem3 tensorflow_p36 $gpu 3 1 true true 300 300
source main2.sh Sol ../data/Sol/Sol_avg_dups.csv regression 1 20 chem3 3 1 rmse true $gpu &
wait

# source main.sh hPXR ../data/hPXR/hPXR_avg_dups.csv regression rmse 256 py27 chem3 tensorflow_p36 $gpu 3 1 true true 300 300
# source main2.sh hPXR ../data/hPXR/hPXR_avg_dups.csv regression 1 20 chem3 3 1 rmse true $gpu

# source main.sh hPXR_class ../data/hPXR_class/hPXR_class_avg_dups.csv classification auc 256 py27 chem3 tensorflow_p36 $gpu 3 1 true true 300 300
# source main2.sh hPXR_class ../data/hPXR_class/hPXR_class_avg_dups.csv classification 1 20 chem3 3 1 auc true $gpu