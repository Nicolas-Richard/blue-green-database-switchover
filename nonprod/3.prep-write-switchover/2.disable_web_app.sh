#!/bin/bash

# Step 1: Rename web_appstate.json to __normal_web_appstate.json
aws s3 mv s3://your-web-app-state-nonprod/web_appstate.json s3://your-web-app-state-nonprod/__normal_web_appstate.json

# Step 2: Rename __degraded_web_appstate.json to web_appstate.json
aws s3 mv s3://your-web-app-state-nonprod/__degraded_web_appstate.json s3://your-web-app-state-nonprod/web_appstate.json
