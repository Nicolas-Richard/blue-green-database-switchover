#!/bin/bash

# Not hard-coding the DB ports in the repo because they might differ for different local SDM setups.

# Connect to the DB with SDM and fetch the DB port.
# Example:
# `sdm connect main-blue3`
# `sdm status | grep main-blue3`

DB_PORT='10017'

python ../../kill_connections.py --db-port $DB_PORT


