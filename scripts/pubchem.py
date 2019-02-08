from chemfp import rdkit_patterns, bitops
from rdkit import Chem, DataStructs
from collections import OrderedDict
import numpy as np
import pickle
import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--data_name", help="dataset name", type=str, required=True)
parser.add_argument("--data_path", help="dataset path", type=str, required=True)
parser.add_argument("--dataset_type", help="dataset type", type=str, choices=['regression', 'classification'], required=True)
args = parser.parse_args()

DATASETS = OrderedDict()
DATASETS[args.data_name] = (args.dataset_type, args.data_path)
placeholder = '__PLACEHOLDER__'

def pubchem_fps(dataset):
    try: 
        os.makedirs('pubchem_fps')
    except OSError:
        if not os.path.isdir('pubchem_fps'):
            raise
    with open(DATASETS[dataset][1], 'r') as f:
        f.readline()
        mols = []
        for line in f:
            smiles = line.strip().split(',')[0]
            mols.append(Chem.MolFromSmiles(smiles))

    dalke_fp=rdkit_patterns.SubstructRDKitFingerprinter_v1.make_fingerprinter()
    pubchem_fps = []
    for mol in mols:
        try:
            text = dalke_fp(mol)
            text = bitops.hex_encode(text)
            text = bin(int('1' + text, 16))[3:]  # keeping leading 0's
            pubchem_fps.append(np.array([int(x) for x in text]))
        except:
            pubchem_fps.append(placeholder)

    fps_sum = np.zeros(888)
    count = 0
    for fp in pubchem_fps:
        if fp != placeholder:
            count += 1
            fps_sum += fp
    average = np.around(fps_sum / count)
    for i, fp in enumerate(pubchem_fps):
        if fp == placeholder:
            pubchem_fps[i] = average
    
    with open(os.path.join('pubchem_fps', dataset + '.pckl'), 'wb') as f:
        pickle.dump(pubchem_fps, f)

for key in DATASETS:
    print(key)
    pubchem_fps(key)