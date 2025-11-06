#!/bin/bash

# Step 1: Rename web_appstate.json back to __degraded_web_appstate.json
aws s3 mv s3://your-web-app-state-prod/web_appstate.json s3://your-web-app-state-prod/__degraded_web_appstate.json

# Step 2: Rename __normal_web_appstate.json back to web_appstate.json
aws s3 mv s3://your-web-app-state-prod/__normal_web_appstate.json s3://your-web-app-state-prod/web_appstate.json
