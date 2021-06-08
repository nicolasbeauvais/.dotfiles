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


def rclone_sync(destination):
    try:
        click.echo('Syncing store...')

        subprocess.check_output([
            'bash',
            '-c',
            'rclone copy --files-from ~/store/backup-list.txt ~/{0} {1}:{0}'.format('store', destination)
        ])


        for path in ['Documents', 'Pictures']:
            click.echo('Syncing {}...'.format(path))
            subprocess.check_output([
                'bash',
                '-c',
                'rclone copy ~/{0} {1}:{0}'.format(path, destination)
            ])
    except subprocess.CalledProcessError as e:
        notify('An error occured while performing a backup between: ~/{0} and {1}:{0}'.format(path, destination))
        click.echo(e.output, err=True)


def delete_backup_list():
    os.remove(os.path.expanduser("~") + '/store/backup-list.txt')


@click.command('backup:local')
@click.argument('media')
def backup_local(media):
    start = time.time()

    if not os.path.isdir('/run/media/ghost/' + media):
        return click.echo('Media {} is not connected.'.format(media), err=True)

    click.echo(click.style('Starting local backup', fg='yellow', bold=True))

    create_backup_list()

    rclone_sync('backup-ssd-crypt')

    delete_backup_list()

    notify('Local backup performed in {:0.0f}s.'.format(time.time() - start))
    click.echo(click.style('Backup done!', fg='green'))


@click.command('backup:cloud')
def backup_cloud():
    start = time.time()

    click.echo(click.style('Starting cloud backup', fg='yellow', bold=True))

    create_backup_list()

    rclone_sync('backup-sw-crypt')

    delete_backup_list()


    notify('Cloud backup performed in {:0.0f}s.'.format(time.time() - start))
    click.echo(click.style('Backup done!', fg='green'))
