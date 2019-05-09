#!/bin/bash

reg_small_datasets=('delaney' 'lipo' 'freesolv' 'qm7' 'qm8')
reg_small_time_datasets=('pdbbind_full' 'pdbbind_core' 'pdbbind_refined')
class_small_datasets=('bace' 'bbbp' 'sider' 'clintox' 'tox21' 'toxcast')
reg_big_datasets=('qm9')
class_big_datasets=('pcba' 'muv' 'hiv' 'chembl')

for i in ${!reg_small_datasets[@]}; do
    mkdir ../data/${reg_small_datasets[$i]}
    cp /data/rsg/chemistry/yangk/clean/chemprop/data/${reg_small_datasets[$i]}.csv ../data/${reg_small_datasets[$i]}/${reg_small_datasets[$i]}.csv
    source create_splits2.sh ${reg_small_datasets[$i]} ../data/${reg_small_datasets[$i]}/${reg_small_datasets[$i]}.csv regression py36_paper_experiments 10 3 false &
done
for i in ${!reg_small_time_datasets[@]}; do
    mkdir ../data/${reg_small_time_datasets[$i]}
    cp /data/rsg/chemistry/yangk/clean/chemprop/data/${reg_small_time_datasets[$i]}.csv ../data/${reg_small_time_datasets[$i]}/${reg_small_time_datasets[$i]}.csv
    source create_splits2.sh ${reg_small_time_datasets[$i]} ../data/${reg_small_time_datasets[$i]}/${reg_small_time_datasets[$i]}.csv regression py36_paper_experiments 10 3 true &
done
for i in ${!class_small_datasets[@]}; do
    mkdir ../data/${class_small_datasets[$i]}
    cp /data/rsg/chemistry/yangk/clean/chemprop/data/${class_small_datasets[$i]}.csv ../data/${class_small_datasets[$i]}/${class_small_datasets[$i]}.csv
    source create_splits2.sh ${class_small_datasets[$i]} ../data/${class_small_datasets[$i]}/${class_small_datasets[$i]}.csv classification py36_paper_experiments 10 3 false &
done
wait
for i in ${!reg_big_datasets[@]}; do
    mkdir ../data/${reg_big_datasets[$i]}
    cp /data/rsg/chemistry/yangk/clean/chemprop/data/${reg_big_datasets[$i]}.csv ../data/${reg_big_datasets[$i]}/${reg_big_datasets[$i]}.csv
    source create_splits2.sh ${reg_big_datasets[$i]} ../data/${reg_big_datasets[$i]}/${reg_big_datasets[$i]}.csv regression py36_paper_experiments 3 1 false &
    wait
done
for i in ${!class_big_datasets[@]}; do
    mkdir ../data/${class_big_datasets[$i]}
    cp /data/rsg/chemistry/yangk/clean/chemprop/data/${class_big_datasets[$i]}.csv ../data/${class_big_datasets[$i]}/${class_big_datasets[$i]}.csv
    source create_splits2.sh ${class_big_datasets[$i]} ../data/${class_big_datasets[$i]}/${class_big_datasets[$i]}.csv classification py36_paper_experiments 3 1 false &
    wait
done