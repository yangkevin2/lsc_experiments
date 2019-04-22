#!/bin/bash

gpu=$1

source main.sh benzene ../../solvent_datasets/benzene/benzene.csv regression r2 128 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu
source main.sh cyclohexan ../../solvent_datasets/cyclohexan/cyclohexan.csv regression r2 128 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu
source main.sh dichlormethan ../../solvent_datasets/dichlormethan/dichlormethan.csv regression r2 128 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu