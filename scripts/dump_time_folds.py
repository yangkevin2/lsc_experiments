import os
import pickle

from collections import OrderedDict
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--data_name", help="dataset name", type=str, required=True)
parser.add_argument("--data_path", help="dataset path", type=str, required=True)
parser.add_argument("--dataset_type", help="dataset type", type=str, choices=['regression', 'classification'], required=True)
args = parser.parse_args()

DATASETS = OrderedDict()
DATASETS[args.data_name] = (args.dataset_type, args.data_path)

for dataset in DATASETS.keys():
    path = DATASETS[dataset][1]
    with open(path, 'r') as rf:
        header = rf.readline()
        count = 0
        for line in rf:
            count += 1
    indices = list(range(count))
    train_cutoff = int(count*0.8)
    val_cutoff = int(count*0.9)
    folds = [indices[:train_cutoff], indices[train_cutoff:val_cutoff], indices[val_cutoff:]]
    for i in range(13):
        os.makedirs(os.path.join(os.path.dirname(path), 'time', 'fold_' + str(i)), exist_ok=True)
        with open(os.path.join(os.path.dirname(path), 'time', 'fold_' + str(i), 'split_indices.pckl'), 'wb') as wf:
            pickle.dump(folds, wf)
    train_path = os.path.join(os.path.dirname(path), dataset + '_train_time.csv')
    val_path = os.path.join(os.path.dirname(path), dataset + '_val_time.csv')
    test_path = os.path.join(os.path.dirname(path), dataset + '_test_time.csv')
    with open(path, 'r') as rf, open(train_path, 'w') as trainf, open(val_path, 'w') as valf, open(test_path, 'w') as testf:
        header = rf.readline().strip()
        trainf.write(header+'\n')
        valf.write(header+'\n')
        testf.write(header+'\n')
        count = 0
        for line in rf:
            if count < train_cutoff:
                trainf.write(line.strip() + '\n')
            elif count < val_cutoff:
                valf.write(line.strip() + '\n')
            else:
                testf.write(line.strip() + '\n')
            count += 1
        
