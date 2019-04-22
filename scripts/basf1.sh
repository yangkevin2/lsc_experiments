#!/bin/bash

gpu=$1

source main.sh dmso ../../solvent_datasets/dmso/dmso.csv regression r2 128 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu
source main.sh ethanol ../../solvent_datasets/ethanol/ethanol.csv regression r2 128 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu
source main.sh ethylacetat ../../solvent_datasets/ethylacetat/ethylacetat.csv regression r2 128 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu