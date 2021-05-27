import os

archives = []

store_path = os.path.expanduser("~") + '/store/'

for dirpath, directories, files in os.walk(store_path, topdown=True):
    if '.git' in directories:
        os.chdir(dirpath)
        # Create archive
        os.system(f'git archive -o {dirpath}.zip HEAD')
        archives.append(dirpath[len(store_path):] + '.zip')

        # Ignore subdirectories
        directories[:] = []

    for file in files:
        if file.endswith('.zip'):
            archives.append(f'{dirpath}/{file}'[len(store_path):])

print('Found ' + str(len(archives)) + ' archives')

rclone = open(os.path.expanduser("~") + '/store/rclone.txt','w')

for archive in archives:
    rclone.write(archive + '\n')

rclone.close()
