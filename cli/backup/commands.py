import os
import subprocess
import click
import time
import notify2

def notify(title, description, urgency=notify2.URGENCY_NORMAL):
    notify2.init('Ghost CLI')
    notification = notify2.Notification(title, description)
    notification.show()


def create_backup_list():
    archives = []

    work_path = os.path.expanduser("~") + '/work/'

    click.echo('\nBuild work list... ', nl=False)

    for dirpath, directories, files in os.walk(work_path, topdown=True):
        if '.git' in directories:
            os.chdir(dirpath)
            # Create archive
            os.system(f'git archive -o {dirpath}.zip HEAD')
            archives.append('{}.zip'.format(dirpath[len(work_path):]))

            # Ignore subdirectories
            directories[:] = []

        for file in files:
            if file.endswith('.zip'):
                archives.append(f'{dirpath}/{file}'[len(work_path):])

    click.echo(click.style('Done', fg='green'))

    backupList = open(os.path.expanduser("~") + '/work/backup-list.txt','w')

    for archive in archives:
        backupList.write(archive + '\n')

    backupList.close()

    return len(archives)


def rsync():
    try:
        click.echo('Syncing work... ', nl=False)

        subprocess.check_output([
            'bash',
            '-c',
            'rsync --archive --delete --verbose --files-from={0} ~/work nasu:Backups/ghost/work'.format(os.path.expanduser("~") + '/work/backup-list.txt')
        ])

        click.echo(click.style('Done', fg='green'))

        click.echo('Syncing Documents... ', nl=False)

        subprocess.check_output([
            'bash',
            '-c',
            'rsync --archive --delete --verbose ~/Documents nasu:~/Backups/ghost'
        ])

        click.echo(click.style('Done', fg='green'))

        click.echo('Syncing Pictures...', nl=False)

        subprocess.check_output([
            'bash',
            '-c',
            'rsync --archive --delete --verbose ~/Pictures nasu:~/Backups/ghost'
        ])

        click.echo(click.style('Done', fg='green'))

        return True
    except subprocess.CalledProcessError as e:
        return e


def delete_backup_list():
    os.remove(os.path.expanduser("~") + '/work/backup-list.txt')



@click.command('backup:nas')
def backup_nas():

    click.echo(click.style('\nStarting Ghost backup', bold=True, ))

    start = time.time()

    archives = create_backup_list()

    status = rsync()

    completion = time.time() - start

    if status is True:
        notify('Ghost backup completed', 'Synced {} archives in {:.2f} seconds'.format(archives, completion))
        click.echo(click.style('\nBackup completed successfully synced {} archives in {:.2f} seconds'.format(archives, completion), fg='green', bold=True))
    else:
        notify('Ghost backup error', 'An error occurred while performing the backup: {}'.format(status), urgency=notify2.URGENCY_CRITICAL)
        click.echo(click.style('\nBackup failed with error: {}'.format(status), fg='red', bold=True), err=True)

    delete_backup_list()
