#!/bin/bash
set -o errexit
set -x  # Add this line to show every command as it's run

# the rest of your script
pip install --upgrade pip
pip install -r requirements.txt
