#!/bin/bash
set -e

# Variables
GIT_SOURCE="v17.3.0"
GIT_DOCKER="v17.3.0"
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
		docker build -t oscm-sles-based \
		    --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
			--build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
			--build-arg HTTP_PROXY="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
			--build-arg HTTPS_PROXY="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
			--build-arg ACTIVATION_CODE_URL=${ACTIVATION_CODE_URL} \
			--build-arg EMAIL_ADDRESS=${EMAIL_ADDRESS} \
			oscm-dockerbuild/oscm-sles-based
	else
		docker build -t oscm-sles-based \
		    --build-arg ACTIVATION_CODE_URL=${ACTIVATION_CODE_URL} \
			--build-arg EMAIL_ADDRESS=${EMAIL_ADDRESS} \
			oscm-dockerbuild/oscm-sles-based
	fi
fi

# Build image for ant commands
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t gc-ant \
	    --build-arg HTTP_PROXY="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg HTTPS_PROXY="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		--build-arg HTTP_PROXY="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg HTTPS_PROXY="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		oscm-dockerbuild/gc-ant
else
	docker build -t gc-ant oscm-dockerbuild/gc-ant
fi

# Load libraries from maven repo via ivy
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker run --name gc-ant-ivy-${TIMESTAMP} --rm -v ${DEVDIR}:/build \
	    -e http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		-e https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		-e HTTP_PROXY="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		-e HTTPS_PROXY="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		-e ANT_OPTS="-Dhttp.proxyHost=${HTTP_PROXY_HOST} -Dhttp.proxyPort=${HTTP_PROXY_PORT} -Dhttps.proxyHost=${HTTPS_PROXY_HOST} -Dhttps.proxyPort=${HTTPS_PROXY_PORT}" \
		gc-ant -f /build/oscm-devruntime/javares/build-oscmaas.xml BUILD.LIB
else
	docker run --name gc-ant-ivy-${TIMESTAMP} --rm -v ${DEVDIR}:/build gc-ant -f /build/oscm-devruntime/javares/build-oscmaas.xml BUILD.LIB
fi

#TODO: delete oscm-build/result/package/*

# Compile CORE components
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker run --name gc-ant-core-${TIMESTAMP} --rm -v ${DEVDIR}:/build \
	    -e http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		-e https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		-e HTTP_PROXY="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		-e HTTPS_PROXY="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		-e ANT_OPTS="-Dhttp.proxyHost=${HTTP_PROXY_HOST} -Dhttp.proxyPort=${HTTP_PROXY_PORT} -Dhttps.proxyHost=${HTTPS_PROXY_HOST} -Dhttps.proxyPort=${HTTPS_PROXY_PORT}" \
		gc-ant -f /build/oscm-devruntime/javares/build-oscmaas.xml BUILD.BES
else
	docker run --name gc-ant-core-${TIMESTAMP} --rm -v ${DEVDIR}:/build gc-ant -f /build/oscm-devruntime/javares/build-oscmaas.xml BUILD.BES
fi

# Compile APP components
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker run --name gc-ant-app-${TIMESTAMP} --rm -v ${DEVDIR}:/build \
	    -e http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		-e https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		-e HTTP_PROXY="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		-e HTTPS_PROXY="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		-e ANT_OPTS="-Dhttp.proxyHost=${HTTP_PROXY_HOST} -Dhttp.proxyPort=${HTTP_PROXY_PORT} -Dhttps.proxyHost=${HTTPS_PROXY_HOST} -Dhttps.proxyPort=${HTTPS_PROXY_PORT}" \
		gc-ant -f /build/oscm-devruntime/javares/build-oscmaas.xml BUILD.APP
else
	docker run --name gc-ant-app-${TIMESTAMP} --rm -v ${DEVDIR}:/build gc-ant -f /build/oscm-devruntime/javares/build-oscmaas.xml BUILD.APP
fi

# Copy necessary files to docker folders
docker run --name ubuntu-copy-${TIMESTAMP} --rm -v ${DEVDIR}:/build ubuntu /bin/bash /build/oscm-dockerbuild/prepare.sh /build

# Build image
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t oscm-tomee \
	    --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		--build-arg HTTP_PROXY="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg HTTPS_PROXY="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		oscm-dockerbuild/oscm-tomee
else
	docker build -t oscm-tomee oscm-dockerbuild/oscm-tomee
fi

# Build final CORE image
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t oscm-core:${GIT_SOURCE} \
	    --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		--build-arg HTTP_PROXY="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg HTTPS_PROXY="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		oscm-dockerbuild/oscm-core
else
	docker build -t oscm-core:${GIT_SOURCE} oscm-dockerbuild/oscm-core
fi

# Build final APP image
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t oscm-app:${GIT_SOURCE} \
	    --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		--build-arg HTTP_PROXY="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg HTTPS_PROXY="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		oscm-dockerbuild/oscm-app
else
	docker build -t oscm-app:${GIT_SOURCE} oscm-dockerbuild/oscm-app
fi

# Build database image
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t oscm-db:${GIT_SOURCE} \
	    --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		--build-arg HTTP_PROXY="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg HTTPS_PROXY="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		oscm-dockerbuild/oscm-db
else
	docker build -t oscm-db:${GIT_SOURCE} --build-arg oscm-dockerbuild/oscm-db
fi

# Build base nginx image
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t oscm-nginx \
	    --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		--build-arg HTTP_PROXY="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg HTTPS_PROXY="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		oscm-dockerbuild/oscm-nginx
else
	docker build -t oscm-nginx --build-arg oscm-dockerbuild/oscm-nginx
fi

# Build branding webserver
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t oscm-branding:${GIT_SOURCE} \
	    --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
	    --build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
	    --build-arg HTTP_PROXY="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
	    --build-arg HTTPS_PROXY="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
	    oscm-dockerbuild/oscm-branding
else
	docker build -t oscm-branding:${GIT_SOURCE} oscm-dockerbuild/oscm-branding
fi

# Build reverse proxy
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t oscm-proxy:${GIT_SOURCE} \
	    --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		--build-arg HTTP_PROXY="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg HTTPS_PROXY="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		oscm-dockerbuild/oscm-proxy
else
	docker build -t oscm-proxy:${GIT_SOURCE} oscm-dockerbuild/oscm-proxy
fi

# Build BIRT Tomcat
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t oscm-birt:${GIT_SOURCE} \
	    --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		--build-arg HTTP_PROXY="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg HTTPS_PROXY="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		oscm-dockerbuild/oscm-birt
else
	docker build -t oscm-birt:${GIT_SOURCE} oscm-dockerbuild/oscm-birt
fi

# Build InitDB
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t oscm-initdb:${GIT_SOURCE} \
	    --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		--build-arg HTTP_PROXY="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" \
		--build-arg HTTPS_PROXY="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" \
		oscm-dockerbuild/oscm-initdb
else
	docker build -t oscm-initdb:${GIT_SOURCE} oscm-dockerbuild/oscm-initdb
fi

# Set latest tag if requested
if [ "${TAG_LATEST}" = "true" ]; then
	docker tag oscm-core:${GIT_SOURCE} oscm-core:latest
	docker tag oscm-app:${GIT_SOURCE} oscm-app:latest
	docker tag oscm-proxy:${GIT_SOURCE} oscm-proxy:latest
	docker tag oscm-branding:${GIT_SOURCE} oscm-branding:latest
	docker tag oscm-birt:${GIT_SOURCE} oscm-birt:latest
	docker tag oscm-initdb:${GIT_SOURCE} oscm-initdb:latest
fi

# Cleanup
#docker rmi oscm-sles-based oscm-nginx gc-ant oscm-tomee
