import os
import subprocess
import click

def create_backup_list():
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

    click.echo('Found ' + str(len(archives)) + ' archives')

    backupList = open(os.path.expanduser("~") + '/store/backup-list.txt','w')

    for archive in archives:
        backupList.write(archive + '\n')

    backupList.close()

def rclone_sync(path, destination):
    try:
        subprocess.check_output([
            'bash',
            '-c',
            'rclone copy --files-from ~/store/backup-list.txt ' + path + ' ' + destination
        ])
    except subprocess.CalledProcessError as e:
        click.echo(e.output, err=True)

def delete_backup_list():
    os.remove(os.path.expanduser("~") + '/store/backup-list.txt')

@click.command('work:info')
def work_info():
    if not os.path.isdir(os.path.expanduser("~") + '/work'):
        return click.echo('Media ' + media + ' is not connected.', err=True)

    click.echo(click.style('Starting local backup', fg='yellow', bold=True))
    create_backup_list()

    click.echo('Syncing...')
    rclone_sync('~/store', 'backup-ssd-crypt:')

    delete_backup_list()
    click.echo(click.style('Backup done!', fg='green'))


@click.command('backup:cloud')
def backup_cloud():
    click.echo(click.style('Starting cloud backup', fg='yellow', bold=True))
    create_backup_list()

    click.echo('Syncing...')
    rclone_sync('~/store', 'backup-sw-crypt:store')

    delete_backup_list()
    click.echo(click.style('Backup done!', fg='green'))
