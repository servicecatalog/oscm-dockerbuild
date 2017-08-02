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

# Process command line options
while getopts 's:d:l' option; do
  case "${option}" in
    s) GIT_SOURCE="${OPTARG}" ;;
    d) GIT_DOCKER="${OPTARG}" ;;
	l) TAG_LATEST="true" ;;
    *) error "Unknown option ${option}" ;;
  esac
done

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

# Build image for ant commands
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t gc-ant --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" --build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" oscm-dockerbuild/gc-ant
else
	docker build -t gc-ant oscm-dockerbuild/gc-ant
fi

# Load libraries from maven repo via ivy
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker run --name gc-ant-ivy-${TIMESTAMP} --rm -v ${DEVDIR}:/build -e http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" -e https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" -e ANT_OPTS="-Dhttp.proxyHost=${HTTP_PROXY_HOST} -Dhttp.proxyPort=${HTTP_PROXY_PORT} -Dhttps.proxyHost=${HTTPS_PROXY_HOST} -Dhttps.proxyPort=${HTTPS_PROXY_PORT}" gc-ant -f /build/oscm-devruntime/javares/build-oscmaas.xml BUILD.LIB
else
	docker run --name gc-ant-ivy-${TIMESTAMP} --rm -v ${DEVDIR}:/build gc-ant -f /build/oscm-devruntime/javares/build-oscmaas.xml BUILD.LIB
fi

#TODO: delete oscm-build/result/package/*

# Compile BES components
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker run --name gc-ant-bes-${TIMESTAMP} --rm -v ${DEVDIR}:/build -e http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" -e https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" -e ANT_OPTS="-Dhttp.proxyHost=${HTTP_PROXY_HOST} -Dhttp.proxyPort=${HTTP_PROXY_PORT} -Dhttps.proxyHost=${HTTPS_PROXY_HOST} -Dhttps.proxyPort=${HTTPS_PROXY_PORT}" gc-ant -f /build/oscm-devruntime/javares/build-oscmaas.xml BUILD.BES
else
	docker run --name gc-ant-bes-${TIMESTAMP} --rm -v ${DEVDIR}:/build gc-ant -f /build/oscm-devruntime/javares/build-oscmaas.xml BUILD.BES
fi

# Compile APP components
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker run --name gc-ant-app-${TIMESTAMP} --rm -v ${DEVDIR}:/build -e http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" -e https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" -e ANT_OPTS="-Dhttp.proxyHost=${HTTP_PROXY_HOST} -Dhttp.proxyPort=${HTTP_PROXY_PORT} -Dhttps.proxyHost=${HTTPS_PROXY_HOST} -Dhttps.proxyPort=${HTTPS_PROXY_PORT}" gc-ant -f /build/oscm-devruntime/javares/build-oscmaas.xml BUILD.APP
else
	docker run --name gc-ant-app-${TIMESTAMP} --rm -v ${DEVDIR}:/build gc-ant -f /build/oscm-devruntime/javares/build-oscmaas.xml BUILD.APP
fi

# Copy necessary files to docker folders
docker run --name ubuntu-copy-${TIMESTAMP} --rm -v ${DEVDIR}:/build ubuntu /bin/bash /build/oscm-dockerbuild/prepare.sh /build

# Build Glassfish image
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t oscm-gf --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" --build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" oscm-dockerbuild/oscm-gf
else
	docker build -t oscm-gf oscm-dockerbuild/oscm-gf
fi

# Build final BES image
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t oscm-bes:${GIT_SOURCE} --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" --build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" oscm-dockerbuild/oscm-bes
else
	docker build -t oscm-bes:${GIT_SOURCE} oscm-dockerbuild/oscm-bes
fi

# Build final APP image
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t oscm-app:${GIT_SOURCE} --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" --build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" oscm-dockerbuild/oscm-app
else
	docker build -t oscm-app:${GIT_SOURCE} oscm-dockerbuild/oscm-app
fi

# Build reverse proxy
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t oscm-proxy:${GIT_SOURCE} --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" --build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" oscm-dockerbuild/oscm-proxy
else
	docker build -t oscm-proxy:${GIT_SOURCE} oscm-dockerbuild/oscm-proxy
fi

# Build branding webserver
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t oscm-branding:${GIT_SOURCE} --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" --build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" oscm-dockerbuild/oscm-branding
else
	docker build -t oscm-branding:${GIT_SOURCE} oscm-dockerbuild/oscm-branding
fi

# Build BIRT Tomcat
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t oscm-tomcat-birt:${GIT_SOURCE} --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" --build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" oscm-dockerbuild/oscm-tomcat-birt
else
	docker build -t oscm-tomcat-birt:${GIT_SOURCE} oscm-dockerbuild/oscm-tomcat-birt
fi

# Build InitDB
if [ ${PROXY_ENABLED} -eq 1 ]; then
	docker build -t oscm-initdb:${GIT_SOURCE} --build-arg http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}" --build-arg https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}" oscm-dockerbuild/oscm-initdb
else
	docker build -t oscm-initdb:${GIT_SOURCE} oscm-dockerbuild/oscm-initdb
fi

# Set latest tag if requested
if [ "${TAG_LATEST}" = "true" ]; then
	docker tag oscm-bes:${GIT_SOURCE} oscm-bes:latest
	docker tag oscm-app:${GIT_SOURCE} oscm-app:latest
	docker tag oscm-proxy:${GIT_SOURCE} oscm-proxy:latest
	docker tag oscm-branding:${GIT_SOURCE} oscm-branding:latest
	docker tag oscm-tomcat-birt:${GIT_SOURCE} oscm-tomcat-birt:latest
	docker tag oscm-initdb:${GIT_SOURCE} oscm-initdb:latest
fi

# Cleanup
#docker rmi gc-ant oscm-gf
