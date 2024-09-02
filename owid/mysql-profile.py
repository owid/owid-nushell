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
import argparse

MYSQL_CONFIG = Path.home() / '.my.cnf'

def list_profiles(config_path):
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


def use_profile(profile, config_path):
    config = _parse_config(config_path)
    name = f'client-{profile}'
    if name not in config:
        print(f'Profile "{profile}" not found in the config file.')
        return
    config['client'] = config[name]
    with open(config_path, 'w') as f:
        config.write(f)


def _parse_config(config_path: str) -> configparser.ConfigParser:
    config = configparser.ConfigParser()
    config.read(config_path)
    return config


def main():
    parser = argparse.ArgumentParser(description='Manage MySQL profiles in ~/.my.cnf')
    subparsers = parser.add_subparsers(dest='command')

    # Subcommand: list
    list_parser = subparsers.add_parser('list', help='List available profiles')
    list_parser.add_argument("--config-path", default=MYSQL_CONFIG, help="Full path to the mysql config file to use")

    # Subcommand: use
    use_parser = subparsers.add_parser('use', help='Switch to a specified profile')
    use_parser.add_argument('profile', help='The profile to switch to')
    use_parser.add_argument("--config-path", default=MYSQL_CONFIG, help="Full path to the mysql config file to use")

    args = parser.parse_args()

    if args.command == 'list':
        list_profiles(args.config_path)
    elif args.command == 'use':
        use_profile(args.profile, args.config_path)
    else:
        parser.print_help()

if __name__ == '__main__':
    main()
