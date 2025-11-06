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
        "Name": "mysql-core-proxy.qa.example.com",
        "Type": "CNAME",
        "TTL": 5,
        "ResourceRecords": [
          {
            "Value": "green-proxy.proxy-xxxxxxxxxxxxxx.us-east-1.rds.amazonaws.com"
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
        "Name": "mysql-core-writer.qa.example.com",
        "Type": "CNAME",
        "TTL": 5,
        "ResourceRecords": [
          {
            "Value": "green-cluster.cluster-xxxxxxxxxxxxxx.us-east-1.rds.amazonaws.com"
          }
        ]
      }
    }
  ]
}'
