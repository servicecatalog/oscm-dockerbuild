#!/bin/bash
set -e

echo $http_proxy
echo $http_proxy

docker build -t oscm-base --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy --build-arg ACTIVATION_CODE=$ACTIVATION_CODE --build-arg EMAIL_ADDRESS=$EMAIL_ADDRESS oscm-base
