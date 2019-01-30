#!/bin/bash

# make sure you are on linux with conda available

conda create -y -n py27_paper_experiments python=2.7
source activate py27_paper_experiments
pip install chemfp
conda install -y -c rdkit rdkit
source deactivate


conda create -y -n py36_paper_experiments python=3.6
source activate py36_paper_experiments
pip install seaborn
pip install -r ../chemprop/requirements.txt
conda install -y pytorch torchvision -c pytorch # assumes cuda 9.0
conda install -y -c anaconda tensorflow-gpu
conda install -y -c rdkit rdkit
pip install nvidia-ml-py3
source deactivate