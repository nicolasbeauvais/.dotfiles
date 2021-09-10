import os
import sys
import click
from dotenv import load_dotenv

load_dotenv()

@click.group()
def cli():
    """GhoST Command line interface"""
    pass


from backup import commands as backup

cli.add_command(backup.backup_nas)


# from work import commands as work

# cli.add_command(work.info)
