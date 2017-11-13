#!/bin/bash

set -e

ZIP_FILE=service.zip

STACK_NAME=cfn-flip-service

bucket=$1
if [ -z $bucket ]; then
    read -p "S3 bucket to store template assets (e.g. mybucket): " bucket
fi

echo "Packaging code..."

./package.sh

echo "Deploying application"

# Do the sam deployment
sam package --template-file template.yaml --s3-bucket $bucket --output-template-file template.out.yaml >/dev/null
sam deploy --template-file template.out.yaml --stack-name $STACK_NAME --capabilities CAPABILITY_IAM >/dev/null

# Clean up
rm $ZIP_FILE
rm template.out.yaml

# Get the URL and test it
url=$(aws cloudformation describe-stacks --stack-name $STACK_NAME | jq -r .Stacks[0].Outputs[0].OutputValue)

curl -X POST -H "Content-Type: application/json" -d '{"API is": "working"}' $url

echo
echo "The API endpoint is: $url"
