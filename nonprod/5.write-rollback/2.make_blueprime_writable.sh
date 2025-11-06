#!/bin/bash

PG_NAME="your-blueprime-cluster-parameter-group"
aws rds modify-db-cluster-parameter-group --db-cluster-parameter-group-name $PG_NAME --parameters "ParameterName=read_only,ParameterValue=0,ApplyMethod=immediate"
