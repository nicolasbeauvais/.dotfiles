import os
import subprocess
import click
import time
from slack_webhook import Slack


def notify(message):
    slack = Slack(url=os.getenv('SLACK_HOOK') + '2Xq4uq9Lw5KtxWI8g0kNfMfv')
    slack.post(text=message)


def create_backup_list():
    archives = []

    store_path = os.path.expanduser("~") + '/store/'

    click.echo('\nBuild store list...')

    for dirpath, directories, files in os.walk(store_path, topdown=True):
        if '.git' in directories:
            os.chdir(dirpath)
            # Create archive
            os.system(f'git archive -o {dirpath}.zip HEAD')
            archives.append('{}.zip'.format(dirpath[len(store_path):]))

            # Ignore subdirectories
            directories[:] = []

        for file in files:
            if file.endswith('.zip'):
                archives.append(f'{dirpath}/{file}'[len(store_path):])

    click.echo('Found {} archives in store'.format(len(archives)))

    backupList = open(os.path.expanduser("~") + '/store/backup-list.txt','w')

    for archive in archives:
        backupList.write(archive + '\n')

    backupList.close()


def rsync():
    try:
        start = time.time()

        click.echo('\nSyncing store...')

        subprocess.check_output([
            'bash',
            '-c',
            'rsync --archive --delete --verbose --files-from={0} ~/store nasu:Backups/ghost/store'.format(os.path.expanduser("~") + '/store/backup-list.txt')
        ])

        click.echo('Syncing Documents...')

        subprocess.check_output([
            'bash',
            '-c',
            'rsync --archive --delete --verbose ~/Documents nasu:~/Backups/ghost'
        ])

        click.echo('Syncing Pictures...')

        subprocess.check_output([
            'bash',
            '-c',
            'rsync --archive --delete --verbose ~/Pictures nasu:~/Backups/ghost'
        ])

        notify('NAS backup performed in {:0.0f}s.'.format(time.time() - start))
    except subprocess.CalledProcessError as e:
        notify('An error occured while performing the backup')
        click.echo(e.output, err=True)



def delete_backup_list():
    os.remove(os.path.expanduser("~") + '/store/backup-list.txt')



@click.command('backup:nas')
def backup_nas():
    click.echo(click.style('Starting backup to NAS', fg='yellow', bold=True))

    create_backup_list()

    rsync()

    delete_backup_list()

    click.echo(click.style('\nBackup done!', fg='green'))
