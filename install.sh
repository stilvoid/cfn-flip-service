#!/bin/bash

BUILD_DIR=./build
SRC_DIR=./src

ZIP_FILE=service.zip

# Copy source
mkdir -p $BUILD_DIR
cp -a $SRC_DIR/* $BUILD_DIR/
pip install -r $SRC_DIR/requirements.txt -t $BUILD_DIR

# Create the zip
cd $BUILD_DIR
zip -9 -r ../$ZIP_FILE ./
cd ..

# Create a bucket
bucket_name=cfn-flip-service-$(pwgen -A -0 8 1)
aws s3 mb s3://$bucket_name

# Do the sam deployment
sam package --template-file template.yaml --s3-bucket $bucket_name --output-template-file template.out.yaml
sam deploy --template-file template.out.yaml --stack-name cfn-flip-service --capabilities CAPABILITY_IAM

# Clean up
aws s3 rm --recursive s3://$bucket_name
aws s3 rb s3://$bucket_name
rm $ZIP_FILE
rm -r $BUILD_DIR
rm template.out.yaml
