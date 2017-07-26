#!/bin/bash
set -e

echo $http_proxy
echo $http_proxy
echo $ACTIVATION_CODE
echo $EMAIL_ADDRESS

pwd
ls

docker build -t oscm-base --build-arg ACTIVATION_CODE=$ACTIVATION_CODE --build-arg EMAIL_ADDRESS=$EMAIL_ADDRESS oscm-dockerbuild/oscm-base/
