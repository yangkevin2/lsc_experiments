#!/bin/bash

source main.sh rPPB_filter ../data/rPPB_filter/rPPB_filter.csv regression rmse 16 py27 chem3 tensorflow_p36
source main.sh hPXR_class ../data/hPXR_class/hPXR_class.csv classification auc 64 py27 chem3 tensorflow_p36
source main.sh hPXR ../data/hPXR/hPXR.csv regression rmse 64 py27 chem3 tensorflow_p36
source main.sh Sol ../data/Sol/Sol.csv regression rmse 64 py27 chem3 tensorflow_p36
source main.sh RLM ../data/RLM/RLM.csv regression rmse 128 py27 chem3 tensorflow_p36