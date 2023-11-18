#!/usr/bin/env python
#
#  mysql-profile
#
#  Switch between mysql profiles. This command manages the [client] section of ~/.my.cnf.
#  To add a profile called "readonly", make [client-readonly] section in ~/my.cnf. Then
#  this command will detect it and let you switch to and from it.
#
# Written by Lars Yencken

from pathlib import Path
import configparser
from dataclasses import dataclass

import click

MYSQL_CONFIG = Path.home() / '.my.cnf'

@click.group()
def cli():
    pass

@cli.command()
@click.option("--config-path", is_flag=False, show_default=True, default=MYSQL_CONFIG, help="Full path to the mysql config file to use")
def list(config_path):
    if not Path(config_path).exists():
        print(f'No config file found at {config_path}')
        return
    config = _parse_config(config_path)
    profiles = []
    for section in config.sections():
        if section.startswith('client-'):
            name = section.split('-', 1)[1]
            profiles.append(name)

    for profile in sorted(profiles):
        print(profile)


@cli.command()
@click.argument('profile')
@click.option("--config-path", is_flag=False, show_default=True, default=MYSQL_CONFIG, help="Full path to the mysql config file to use")
def use(profile, config_path):
    config = _parse_config(config_path)
    name = f'client-{profile}'
    config['client'] = config[name]
    with open(config_path, 'w') as f:
        config.write(f)


def _parse_config(configPath: str) -> configparser.ConfigParser:
    config = configparser.ConfigParser()
    config.read(configPath)
    return config


if __name__ == '__main__':
    cli()