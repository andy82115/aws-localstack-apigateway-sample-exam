#!/usr/bin/env sh

set -x

# Get the API Gateway ID
restapi=$(awslocal apigateway get-rest-apis | jq -r '.items[0].id')

# Construct the endpoint URL
endpoint="http://${restapi}.execute-api.localhost.localstack.cloud:4566/dev/secret"

# Define the payload as a parameter
payload='{"action":"update", "secret":{"password":"new-password"}}'

# Make the curl request and capture the response
response=$(curl -s -X POST -H "Content-Type: application/json" -d "$payload" "$endpoint")

# Output the response for debugging purposes
echo "$response"

# Enhanced validation logic
if echo "$response" | grep -q '"message":"Secret updated successfully"'; then
    echo "Test passed: Secret updated successfully."
    exit 0
elif echo "$response" | grep -q '"message":"Failed to process request"'; then
    echo "Test failed: Error during secret update. Details: $response"
    exit 1
else
    echo "Test failed: Unexpected response. Details: $response"
    exit 1
fi