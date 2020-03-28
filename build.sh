#!/bin/sh

# Cleanup
rm -rf $PWD/layers

# Build Docker image
docker build -t opencv2-lambda-layer .

# Create layer folder
mkdir -p $PWD/layers/3.7/opt $PWD/layers/3.8/opt

# Extract layer data from image and save to layer folder
docker create -ti --name dummy opencv2-lambda-layer bash
docker cp dummy:/opt/opencv-python-3.7 $PWD/layers/3.7/opt/opencv-python-3.7
docker cp dummy:/opt/opencv-python-3.8 $PWD/layers/3.8/opt/opencv-python-3.8
docker rm -f dummy

# Publish layer
sls deploy