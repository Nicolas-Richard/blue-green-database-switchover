#!/bin/bash

# https://console.aws.amazon.com/route53/v2/hostedzones?region=us-east-1#ListRecordSets/ZYYYYYYYYYYYYYY

####################################################################################################
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
            "Value": "blueprime-cluster-batch.cluster-custom-yyyyyyyyyyyyyy.us-east-1.rds.amazonaws.com"
          }
        ]
      }
    }
  ]
}'
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
            "Value": "blueprime-cluster-live.cluster-custom-yyyyyyyyyyyyyy.us-east-1.rds.amazonaws.com"
          }
        ]
      }
    }
  ]
}'
####################################################################################################
aws route53 change-resource-record-sets \
  --hosted-zone-id ZYYYYYYYYYYYYYY \
  --change-batch '{
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "mysql-core-proxy.prod.example.com",
        "Type": "CNAME",
        "TTL": 5,
        "ResourceRecords": [
          {
            "Value": "blueprime-proxy.proxy-yyyyyyyyyyyyyy.us-east-1.rds.amazonaws.com"
          }
        ]
      }
    }
  ]
}'
####################################################################################################
aws route53 change-resource-record-sets \
  --hosted-zone-id ZYYYYYYYYYYYYYY \
  --change-batch '{
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "mysql-core-writer.prod.example.com",
        "Type": "CNAME",
        "TTL": 5,
        "ResourceRecords": [
          {
            "Value": "blueprime-cluster.cluster-yyyyyyyyyyyyyy.us-east-1.rds.amazonaws.com"
          }
        ]
      }
    }
  ]
}'

