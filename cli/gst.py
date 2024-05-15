import click
from dotenv import load_dotenv
from backup import commands

load_dotenv()

@click.group()
def cli():
    """GhoST Command line interface"""
    pass

cli.add_command(commands.backup_nas)

if __name__ == '__main__':
    cli()
