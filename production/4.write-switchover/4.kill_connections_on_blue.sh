#!/bin/bash

# Not hard-coding the DB ports in the repo because they might differ for different local SDM setups.

# Connect to the DB with SDM and fetch the DB port.
# Example:
# `sdm connect main-blue3`
# `sdm status | grep main-blue3`

DB_PORT='11112'
#DB_PORT_READER_1='10177'
#DB_PORT_READER_2='10178'
#DB_PORT_BATCH_READER_1='10175'
#DB_PORT_BATCH_READER_2='10176'

python ../../kill_connections.py --db-port $DB_PORT

# python ../../kill_connections.py --db-port $DB_PORT_READER_1
# python ../../kill_connections.py --db-port $DB_PORT_READER_2
# python ../../kill_connections.py --db-port $DB_PORT_BATCH_READER_1
# python ../../kill_connections.py --db-port $DB_PORT_BATCH_READER_2
