import pickle
import os
import numpy as np
from collections import OrderedDict
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
for name in DATASETS:
    print(name)
    all_fps = []
    paths = [os.path.join('maccs', name + '.pckl'), 
             os.path.join('pubchem_fps', name + '.pckl'),
             os.path.join('shed_cats2d_fp', name + '.pckl'),
             os.path.join('rdkfp', name + '.pckl')]
    for path in paths:
        with open(path, 'rb') as f:
            if 'pubchem' in path:
                fps = pickle.load(f, encoding='latin1')
            else:
                fps = pickle.load(f)
            all_fps.append(fps)
    
    assert len(all_fps[0]) == len(all_fps[1]) == len(all_fps[2]) == len(all_fps[3])

    combined_fps = []
    for i in range(len(all_fps[0])):
        combined_fps.append(np.concatenate([fp[i] for fp in all_fps]).astype(float))
        for j in range(4):
            all_fps[j][i] = None

    features = np.stack(combined_fps)
    sparse_features = sparse.csr_matrix(features)

    with open(os.path.join('semiF', name + '.pckl'), 'wb') as f:
        pickle.dump(sparse_features, f)
