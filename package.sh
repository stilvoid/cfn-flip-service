#!/bin/bash

set -e

BUILD_DIR=./build
SRC_DIR=./src

ZIP_FILE=package.zip

BUCKET=$1
if [ -z $BUCKET ]; then
    read -p "S3 bucket to store template assets (e.g. mybucket): " bucket
fi

# Copy source
mkdir -p $BUILD_DIR
cp -a $SRC_DIR/* $BUILD_DIR/
pip install -r $SRC_DIR/requirements.txt -t $BUILD_DIR > /dev/null

# Create the zip
cd $BUILD_DIR
zip -9 -r ../$ZIP_FILE ./ >/dev/null
cd ..
rm -r $BUILD_DIR

# Create the sam template
aws cloudformation package --template-file template.yaml --s3-bucket $BUCKET --output-template-file package.yaml >/dev/null
