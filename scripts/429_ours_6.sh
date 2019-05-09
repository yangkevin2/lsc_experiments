#!/bin/bash

gpu=$1

source main.sh qm9 ../data/qm9/qm9.csv regression mae 512 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 3 1 false false 300 300