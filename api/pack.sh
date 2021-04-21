#!/bin/sh

# this will run in a subshell, hence it will not change afterwards the current PWD
(cd package && zip -r /lambda/api.zip .)

chmod 755 main.py modules/*.py
zip -g /lambda/api.zip main.py modules/*.py
chmod 755 /lambda/api.zip
