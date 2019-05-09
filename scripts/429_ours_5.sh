#!/bin/bash

gpu=$1

source main.sh qm8 ../data/qm8/qm8.csv regression mae 256 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 10 3 false true 300 300