#!/bin/bash

# Not hard-coding the DB ports in the repo because they might differ for different local SDM setups.

# Connect to the DB with SDM and fetch the DB port.
# Example:
# `sdm connect main-blue3`
# `sdm status | grep main-blue3`

# Need to fire a script to kill connections for each DB instance
# Need to have SDM configured for each instance...

DB_PORT_READER_1='10181'
DB_PORT_READER_2='10182'
DB_PORT_BATCH_READER_1='10179'
DB_PORT_BATCH_READER_2='10180'

python ../../kill_connections.py --db-port $DB_PORT_READER_1
python ../../kill_connections.py --db-port $DB_PORT_READER_2
python ../../kill_connections.py --db-port $DB_PORT_BATCH_READER_1
python ../../kill_connections.py --db-port $DB_PORT_BATCH_READER_2

