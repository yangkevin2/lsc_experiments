import os

for folder in os.listdir('.'):
    try:
        with open(os.path.join(folder, 'verbose.log'), 'r') as f:
            for line in f:
                last_line = line.strip()
        print(folder, last_line)
    except:
        print(folder, 'failed')