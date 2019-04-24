import os
import numpy as np
from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument("--num_test_folds", help="num test folds for each split", type=int, default=10)
args = parser.parse_args()

folders = ['../compare_lsc_random',
           '../compare_lsc_scaffold',
           '../compare_lsc_time',
           '../compare_lsc_time_window/random',
           '../compare_lsc_time_window/scaffold',
           '../compare_lsc_time_window/time']

for folder in folders:
    print(folder)
    try:
        for dataset in os.listdir(folder):
            try:
                all_scores = []
                scores = 0
                count = 0
                for fold in range(args.num_test_folds):
                    last_line = None
                    with open(os.path.join(folder, dataset, 'test', 'fold_' + str(fold), 'semi', 'dbg', 'o0003.dbg'), 'r') as f:
                        for line in f:
                            if len(line.strip()) > 0:
                                last_line = line.strip()
                    scores += float(last_line)
                    all_scores.append(float(last_line))
                    count += 1
                print('{}: {} +/- {}'.format(dataset, str(scores/count), str(np.std(all_scores))))
            except:
                print('{}: failed'.format(dataset))
    except:
        pass