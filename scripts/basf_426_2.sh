#!/bin/bash

gpu=$1

source main.sh thf ../data/thf/thf.csv regression r2 256 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 3 1 false true 300 300
source main.sh toluol ../data/toluol/toluol.csv regression r2 256 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 3 1 false true 300 300
source main.sh benzene ../data/benzene/benzene.csv regression r2 256 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 3 1 false true 300 300