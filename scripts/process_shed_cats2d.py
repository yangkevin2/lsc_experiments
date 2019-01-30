import pickle
import os
import numpy as np
from collections import OrderedDict
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--data_name", help="dataset name", type=str, required=True)
parser.add_argument("--data_path", help="dataset path", type=str, required=True)
parser.add_argument("--dataset_type", help="dataset type", type=str, choices=['regression', 'classification'], required=True)
args = parser.parse_args()

DATASETS = OrderedDict()
DATASETS[args.data_name] = (args.dataset_type, args.data_path)

os.makedirs('shed_cats2d_fp', exist_ok=True)
for name in DATASETS:
    shed_fp = []
    with open(os.path.join('raw/fingerprints', name + '_SHED.fpf'), 'r') as rf:
        for line in rf:
            line = line.strip().split('\t')
            line = line[1:]
            line = [float(x[3:]) for x in line]
            shed_fp.append(np.array(line))
    
    cats2d_fp = []
    with open(os.path.join('raw/fingerprints', name + '_CATS2D.fpf'), 'r') as rf:
        for line in rf:
            line = line.strip().split('\t')
            line = line[1:]
            line = [float(x.split(':')[1]) for x in line]
            cats2d_fp.append(np.array(line))
    
    assert len(shed_fp) == len(cats2d_fp)
    fp = [np.concatenate([shed_fp[i], cats2d_fp[i]]) for i in range(len(shed_fp))]

    with open(os.path.join('shed_cats2d_fp', name + '.pckl'), 'wb') as f:
        pickle.dump(fp, f)
    
