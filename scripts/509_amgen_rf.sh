#!/bin/bash

source main2_rf.sh rPPB_filter ../data/rPPB_filter/rPPB_filter_avg_dups.csv regression 1 20 chem3 3 1 rmse true 0
source main2_rf.sh Sol ../data/Sol/Sol_avg_dups.csv regression 1 20 chem3 3 1 rmse true 0
source main2_rf.sh hPXR ../data/hPXR/hPXR_avg_dups.csv regression 1 20 chem3 3 1 rmse true 0
source main2_rf.sh hPXR_class ../data/hPXR_class/hPXR_class_avg_dups.csv classification 1 20 chem3 3 1 auc true 0
source main2_rf.sh RLM ../data/RLM/RLM_avg_dups.csv regression 1 20 chem3 1 1 rmse true 0
