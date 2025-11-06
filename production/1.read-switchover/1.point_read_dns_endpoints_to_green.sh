#!/bin/bash

# https://console.aws.amazon.com/route53/v2/hostedzones?region=us-east-1#ListRecordSets/ZYYYYYYYYYYYYYY

####################################################################################################
# README : This is the last step of the read-switchover
# we execute this after services are already using green via env var.
# And when we have confirmed that the performance on the green reader is good.
####################################################################################################

aws route53 change-resource-record-sets \
  --hosted-zone-id ZYYYYYYYYYYYYYY \
  --change-batch '{
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "mysql-core-reader.prod.example.com",
        "Type": "CNAME",
        "TTL": 5,
        "ResourceRecords": [
          {
            "Value": "green-cluster-live.cluster-custom-yyyyyyyyyyyyyy.us-east-1.rds.amazonaws.com"
          }
        ]
      }
    }
  ]
}'

aws route53 change-resource-record-sets \
  --hosted-zone-id ZYYYYYYYYYYYYYY \
  --change-batch '{
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "mysql-core-batch-reader.prod.example.com",
        "Type": "CNAME",
        "TTL": 5,
        "ResourceRecords": [
          {
            "Value": "green-cluster-batch.cluster-custom-yyyyyyyyyyyyyy.us-east-1.rds.amazonaws.com"
          }
        ]
      }
    }
  ]
}'
