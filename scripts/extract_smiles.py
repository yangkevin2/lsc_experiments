import os
from collections import OrderedDict
import pandas as pd
from rdkit.Chem import PandasTools
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--data_name", help="dataset name", type=str, required=True)
parser.add_argument("--data_path", help="dataset path", type=str, required=True)
parser.add_argument("--dataset_type", help="dataset type", type=str, choices=['regression', 'classification'], required=True)
args = parser.parse_args()

DATASETS = OrderedDict()
DATASETS[args.data_name] = (args.dataset_type, args.data_path)

os.makedirs('sdfs', exist_ok=True)
for name in DATASETS:
    print(name)
    all_smiles = []
    with open(DATASETS[name][1], 'r') as rf, open(os.path.join('sdfs', name + '_smiles.csv'), 'w') as wf:
        rf.readline()
        for line in rf:
            smiles = line.strip().split(',')[0]
            wf.write(smiles + '\n')
            all_smiles.append(smiles)

    filename = os.path.join('sdfs', name + '_smiles.csv')
    pp = pd.DataFrame(all_smiles, columns=['Smiles'])
    PandasTools.AddMoleculeColumnToFrame(pp,'Smiles','Molecule') # pp = doesn't work for me
    PandasTools.WriteSDF(pp, os.path.join('sdfs', name + '.sdf'), molColName='Molecule', properties=list(pp.columns))
