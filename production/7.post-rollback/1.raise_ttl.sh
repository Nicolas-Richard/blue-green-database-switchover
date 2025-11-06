#!/bin/bash

# https://console.aws.amazon.com/route53/v2/hostedzones?region=us-east-1#ListRecordSets/ZYYYYYYYYYYYYYY

python ../../update_record_ttl.py "prod.example.com" "mysql-core-batch-reader.prod.example.com." "raise"
python ../../update_record_ttl.py "prod.example.com" "mysql-core-reader.prod.example.com." "raise"
python ../../update_record_ttl.py "prod.example.com" "mysql-core-proxy.prod.example.com." "raise"
python ../../update_record_ttl.py "prod.example.com" "mysql-core-writer.prod.example.com." "raise"
