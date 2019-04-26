#!/bin/bash

gpu=$1

source main.sh freesolv ../data/freesolv/freesolv.csv regression r2 256 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 3 1 true true 300 300
source main2.sh freesolv ../data/freesolv/freesolv.csv regression 1 20 py36_paper_experiments 3 1 r2 true $gpu