#!/bin/bash

# https://console.aws.amazon.com/route53/v2/hostedzones?region=us-east-1#ListRecordSets/ZXXXXXXXXXXXXX

####################################################################################################
aws route53 change-resource-record-sets \
  --hosted-zone-id ZXXXXXXXXXXXXX \
  --change-batch '{
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "mysql-core-batch-reader.qa.example.com",
        "Type": "CNAME",
        "TTL": 5,
        "ResourceRecords": [
          {
            "Value": "blue-cluster-batch.cluster-custom-xxxxxxxxxxxxxx.us-east-1.rds.amazonaws.com"
          }
        ]
      }
    }
  ]
}'

####################################################################################################
aws route53 change-resource-record-sets \
  --hosted-zone-id ZXXXXXXXXXXXXX \
  --change-batch '{
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "mysql-core-reader.qa.example.com",
        "Type": "CNAME",
        "TTL": 5,
        "ResourceRecords": [
          {
            "Value": "blue-cluster-live.cluster-custom-xxxxxxxxxxxxxx.us-east-1.rds.amazonaws.com"
          }
        ]
      }
    }
  ]
}'
