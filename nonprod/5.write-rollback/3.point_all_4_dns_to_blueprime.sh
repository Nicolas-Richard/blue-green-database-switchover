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
            "Value": "blueprime-cluster-batch.cluster-custom-xxxxxxxxxxxxxx.us-east-1.rds.amazonaws.com"
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
            "Value": "blueprime-cluster-live.cluster-custom-xxxxxxxxxxxxxx.us-east-1.rds.amazonaws.com"
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
        "Name": "mysql-core-proxy.qa.example.com",
        "Type": "CNAME",
        "TTL": 5,
        "ResourceRecords": [
          {
            "Value": "blueprime-proxy.proxy-xxxxxxxxxxxxxx.us-east-1.rds.amazonaws.com"
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
            "Value": "blueprime-cluster.cluster-xxxxxxxxxxxxxx.us-east-1.rds.amazonaws.com"
          }
        ]
      }
    }
  ]
}'

