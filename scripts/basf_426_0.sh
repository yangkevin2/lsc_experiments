#!/bin/bash

gpu=$1

source main.sh dichlormethan ../data/dichlormethan/dichlormethan.csv regression r2 256 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 3 1 false true 300 300
source main.sh dmso ../data/dmso/dmso.csv regression r2 256 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 3 1 false true 300 300
source main.sh ethanol ../data/ethanol/ethanol.csv regression r2 256 py27_paper_experiments py36_paper_experiments py36_paper_experiments $gpu 3 1 false true 300 300