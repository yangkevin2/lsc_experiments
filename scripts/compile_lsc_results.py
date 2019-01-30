import os
import numpy as np

folders = ['../compare_lsc_random', '../compare_lsc_scaffold', '../compare_lsc_time']

for folder in folders:
    print(folder)
    try:
        for dataset in os.listdir(folder):
            try:
                all_scores = []
                scores = 0
                count = 0
                for fold in range(3, 13):
                    last_line = None
                    with open(os.path.join(folder, dataset, 'fold_' + str(fold), 'semi', 'dbg', 'o0003.dbg'), 'r') as f:
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