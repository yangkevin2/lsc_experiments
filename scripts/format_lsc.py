import pickle
import os
from collections import OrderedDict
import numpy as np
from scipy import sparse
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--data_name", help="dataset name", type=str, required=True)
parser.add_argument("--data_path", help="dataset path", type=str, required=True)
parser.add_argument("--dataset_type", help="dataset type", type=str, choices=['regression', 'classification'], required=True)
args = parser.parse_args()

DATASETS = OrderedDict()
DATASETS[args.data_name] = (args.dataset_type, args.data_path)

os.makedirs('semiF', exist_ok=True)
os.makedirs('lsc_data', exist_ok=True)

with open('indices.pckl', 'rb') as f:
    indices = pickle.load(f)
with open('targetNames.pckl', 'rb') as f:
    target_names = pickle.load(f)

for dataset in DATASETS:
    print(dataset)
    dataset_type, path = DATASETS[dataset][0], DATASETS[dataset][1]
    all_labels = []
    num_lines = 0
    with open(path, 'r') as f:
        header = f.readline()
        header = header.strip().split(',')[1:]
        for line in f:
            num_lines += 1
            labels = line.strip().split(',')[1:]
            if dataset_type == 'classification':
                for i in range(len(labels)):
                    if labels[i] == '0' or labels[i] == '0.0':
                        labels[i] = -1
                    elif labels[i] == '1' or labels[i] == '1.0':
                        labels[i] = 1
                    elif labels[i] == '':
                        labels[i] = 0
                    else:
                        assert False
            else:
                for i in range(len(labels)):
                    if labels[i] == '':
                        labels[i] = '0'
                    labels[i] = float(labels[i])
            all_labels.append(np.array(labels))
    all_labels = np.stack(all_labels)
    all_labels = sparse.csr_matrix(all_labels)
    folder = os.path.join('lsc_data', dataset)
    os.makedirs(folder, exist_ok=True)
    with open(os.path.join(folder, 'labelsHard.pckl'), 'wb') as f:
        pickle.dump(all_labels, f)
        pickle.dump(indices[:num_lines], f)
        pickle.dump(target_names[:len(header)], f)  # not actually correct header labels but don't really care about these for our purposes
    
    with open(os.path.join('semiF', dataset + '.pckl'), 'rb') as f:
        features = pickle.load(f)
    assert features.shape[0] == num_lines
    with open(os.path.join(folder, 'semi.pckl'), 'wb') as f:
        pickle.dump(features, f)
        pickle.dump(indices[:num_lines], f)
    
        
