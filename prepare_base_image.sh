#!/bin/bash
set -e

docker build -t oscm-sles-based --build-arg HTTP_PROXY=$http_proxy --build-arg HTTPS_PROXY=$https_proxy --build-arg ACTIVATION_CODE=$ACTIVATION_CODE --build-arg EMAIL_ADDRESS=$EMAIL_ADDRESS oscm-dockerbuild/oscm-sles-based/
