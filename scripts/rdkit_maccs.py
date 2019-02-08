from rdkit import Chem, DataStructs
from rdkit.Chem import MACCSkeys, RDKFingerprint
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

def fps(dataset):
    os.makedirs('maccs', exist_ok=True)
    os.makedirs('rdkfp', exist_ok=True)
    with open(DATASETS[dataset][1], 'r') as f:
        f.readline()
        mols = []
        for line in f:
            smiles = line.strip().split(',')[0]
            mols.append(Chem.MolFromSmiles(smiles))
    maccs_fps = [np.array([y for y in MACCSkeys.GenMACCSKeys(x)]) for x in mols]

    with open(os.path.join('maccs', dataset + '.pckl'), 'wb') as f:
        pickle.dump(maccs_fps, f)

    rdk_fps = []
    for mol in mols:
        text = Chem.RDKFingerprint(mol, maxPath=6).ToBitString()
        text = np.array([x for x in text])
        rdk_fps.append(text)
    
    with open(os.path.join('rdkfp', dataset + '.pckl'), 'wb') as f:
        pickle.dump(rdk_fps, f)

for key in DATASETS:
    print(key)
    fps(key)

