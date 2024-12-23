#!/usr/bin/env sh

set -x

# Get the API Gateway ID
restapi=$(awslocal apigateway get-rest-apis | jq -r '.items[0].id')

# Construct the endpoint URL
endpoint="http://${restapi}.execute-api.localhost.localstack.cloud:4566/dev/secret"

# Define the payload as a parameter
payload='{"action":"get"}'

# Make the curl request and capture the response
response=$(curl -s -X POST -H "Content-Type: application/json" -d "$payload" "$endpoint")

# Output the response for debugging purposes
echo "$response"

# Check if the response contains the expected secret or error
if echo "$response" | grep -q "Failed to retrieve secret"; then
    echo "Test failed: Unable to retrieve secret from Secrets Manager."
    exit 1
else
    echo "Test passed: Successfully retrieved secret."
fi