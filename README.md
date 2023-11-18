# Nushell tools for Our World In Data

This repository is a collection of custom commands that I found useful for working with OWID data. It is mostly written for myself and other OWID staff members but since much of our tools are open, they should be useable by members of the public to a significant degree.

To use these tools you need a recent version of [Nushell](http://www.nushell.sh/) installed (version 0.86 or higher at the time of writing this). Then load the scripts in the owid subfolder of this repo as an overlay like this:
```
overlay use --prefix /path/to/owid-nushell/owid
```

This will bring all the tools into scope as an overlay - you can hide all owid commands again with `overlay hide`.

The commands all have tab complection and help texts, so just type `owid` and hit <tab> to see what the available commands are or browse the source.

### Aliases file

If you want to save yourself some typing then the aliases might be useful. To use them do the following:

```
source /path/to/owid-nushell/aliases.nu
```

The you can access all commands by mnemonics that use the first letter per level, e.g. `owid api metadata` becomes `oam`

### Mysql

Using this requires the mysqlsh tool installed. Get in on the mac with `brew install mysql-shell`. Then add/edit a file in `~/.my.cnf` to put in the credential options (use `owid mysql profiles list`). You can add as many [client-] sections as you like to quickly switch between multiple mysql servers. For production, please make sure to use a read only account :)

```
[client]
user = ***
password = ***
host = owid-live-db
port = 3306
database = live_grapher

[client-prod-ro]
user = ***
password = ***
host = owid-live-db
port = 3306
database = live_grapher

[client-local]
user = grapher
password = grapher
host = localhost
port = 3307
database = grapher

```