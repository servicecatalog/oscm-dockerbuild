 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2020                                            *
 #*                                                                           *
 #* Creation Date: 16-07-2020                                                 *
 #*                                                                           *
 #*****************************************************************************

#!/bin/bash
set -e

# Variables
TAG_LATEST="false"
TIMESTAMP=$(date +%s)
WORKDIR="$(dirname $(readlink -f $0))/work"
DEVDIR="${WORKDIR}/development"
HTTP_PROXY_HOST=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f1)
HTTP_PROXY_PORT=$(echo $http_proxy | cut -d'/' -f3 | cut -d':' -f2)
HTTPS_PROXY_HOST=$(echo $https_proxy | cut -d'/' -f3 | cut -d':' -f1)
HTTPS_PROXY_PORT=$(echo $https_proxy | cut -d'/' -f3 | cut -d':' -f2)

if [ -z ${HTTP_PROXY_HOST} ] && [ -z ${HTTP_PROXY_PORT} ] && [ -z ${HTTPS_PROXY_HOST} ] && [ -z ${HTTPS_PROXY_PORT} ]; then
	PROXY_ENABLED=0
else
	PROXY_ENABLED=1
fi

# Print usage
usage() {
  printf -- "Usage: $0 -s <git-source> -d <git-docker> -a <activation-code> -e <e-mail-address> [-l]\n"
  printf -- "-s STRING\tgit tag or branch of development (source code) repository\n"
  printf -- "-d STRING\tgit tag or branch of oscm-dockerbuild repository (also used for resulting Docker image tag)\n"
  printf -- "-a STRING\tURL to the file containing the activation code for the temporary SLES base image\n"
  printf -- "-e STRING\te-mail address used for registering the temporary SLES base image\n"
  printf -- "-l\t\tIn the resulting local Docker images, additionally set the \"latest\" tag\n"
  exit 0
}

# Process command line options
while getopts ':s:d:a:e:l' option; do
  case "${option}" in
    s) GIT_SOURCE="${OPTARG}" ;;
    d) GIT_DOCKER="${OPTARG}" ;;
	a) ACTIVATION_CODE_URL="${OPTARG}" ;;
	e) EMAIL_ADDRESS="${OPTARG}" ;;
	l) TAG_LATEST="true" ;;
    *) usage ;;
  esac
done

# Make sure that mandatory stuff is set
if [ -z "${GIT_SOURCE}" ] || [ -z "${GIT_DOCKER}" ] || [ -z "${ACTIVATION_CODE_URL}" ] || [ -z "${EMAIL_ADDRESS}" ]; then
    usage
fi

# Create working directory
if [ ! -d ${WORKDIR} ]; then
	mkdir ${WORKDIR}
fi

# Update or clone git repositories
if [ ! -d ${DEVDIR} ]; then
	cd ${WORKDIR}
	git clone https://github.com/servicecatalog/development.git --depth 1 --branch ${GIT_SOURCE}
	cd ${DEVDIR}
fi
if [ ! -d ${DEVDIR}/oscm-dockerbuild ]; then
	git clone https://github.com/servicecatalog/oscm-dockerbuild.git --depth 1 --branch ${GIT_DOCKER}
	cd oscm-dockerbuild
	cd ${DEVDIR}
fi

cd ${DEVDIR}

#Build registered sles bases image
if [ -z ${ACTIVATION_CODE_URL} ] && [ -z ${EMAIL_ADDRESS} ]; then
	usage
else
	if [ ${PROXY_ENABLED} -eq 1 ]; then
		docker build -t oscm-sles-based --build-arg HTTP_PROXY="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" --build-arg HTTPS_PROXY="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" --build-arg ACTIVATION_CODE_URL=${ACTIVATION_CODE_URL} --build-arg EMAIL_ADDRESS=${EMAIL_ADDRESS} oscm-dockerbuild/oscm-sles-based
	else
		docker build -t oscm-sles-based --build-arg ACTIVATION_CODE_URL=${ACTIVATION_CODE_URL} --build-arg EMAIL_ADDRESS=${EMAIL_ADDRESS} oscm-dockerbuild/oscm-sles-based
	fi
fi