import os

for folder in os.listdir('.'):
    try:
        if folder.endswith('time_window'):
            for subfolder in os.listdir(folder):
                try:
                    with open(os.path.join(folder, subfolder, 'verbose.log'), 'r') as f:
                        for line in f:
                            last_line = line.strip()
                    print(folder, subfolder, last_line)
                except:
                    print(folder, subfolder, 'failed')
        else:
            with open(os.path.join(folder, 'verbose.log'), 'r') as f:
                for line in f:
                    last_line = line.strip()
            print(folder, last_line)
    except:
        print(folder, 'failed')