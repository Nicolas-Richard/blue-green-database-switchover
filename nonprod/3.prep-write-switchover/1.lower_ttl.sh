#!/bin/bash

# https://console.aws.amazon.com/route53/v2/hostedzones?region=us-east-1#ListRecordSets/ZXXXXXXXXXXXXX

# python ../../update_record_ttl.py $zone $record_to_update "lower" # options are ["lower", "raise"]

python ../../update_record_ttl.py "qa.example.com" "mysql-core-batch-reader.qa.example.com." "lower"
python ../../update_record_ttl.py "qa.example.com" "mysql-core-reader.qa.example.com." "lower"
python ../../update_record_ttl.py "qa.example.com" "mysql-core-proxy.qa.example.com." "lower"
python ../../update_record_ttl.py "qa.example.com" "mysql-core-writer.qa.example.com." "lower"
