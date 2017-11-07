#!/bin/bash
# Variables for this script
COMPOSE_CONFIG_PATH=/opt
TARGET_PATH=/target

# If ${TARGET_PATH}/var.env does not exist, just copy the template for the operator and exit
if [ ! -f ${TARGET_PATH}/var.env ] || [ ! -f ${TARGET_PATH}/.env ]; then
    cp /opt/env.template ${TARGET_PATH}/.env
    cp /opt/var.env.template ${TARGET_PATH}/var.env
    exit 0
fi

# Enable automatic exporting of variables
set -a
# Read configuration files
source ${TARGET_PATH}/.env
# Disable automatic exporting of variables
set +a
# Exit on error
set -e

# Create Docker directories if they do not exist yet
for docker_directory in \
    ${TARGET_PATH}/data/oscm-db/data \
    ${TARGET_PATH}/config/certs \
    ${TARGET_PATH}/config/oscm-branding/brandings \
    ${TARGET_PATH}/config/oscm-core/ssl/privkey \
    ${TARGET_PATH}/config/oscm-core/ssl/cert \
    ${TARGET_PATH}/config/oscm-core/ssl/chain \
    ${TARGET_PATH}/config/oscm-app/ssl/privkey \
    ${TARGET_PATH}/config/oscm-app/ssl/cert \
    ${TARGET_PATH}/config/oscm-app/ssl/chain \
    ${TARGET_PATH}/config/oscm-birt/ssl/privkey \
    ${TARGET_PATH}/config/oscm-birt/ssl/cert \
    ${TARGET_PATH}/config/oscm-birt/ssl/chain \
    ${TARGET_PATH}/config/oscm-branding/ssl/privkey \
    ${TARGET_PATH}/config/oscm-branding/ssl/cert \
    ${TARGET_PATH}/config/oscm-branding/ssl/chain \
    ${TARGET_PATH}/logs/oscm-app \
    ${TARGET_PATH}/logs/oscm-birt \
    ${TARGET_PATH}/logs/oscm-branding \
    ${TARGET_PATH}/logs/oscm-core \
    ${TARGET_PATH}/logs/oscm-db; do
    if [ ! -d ${docker_directory} ]; then
        mkdir -p ${docker_directory}
    fi
done

# Create Docker log files if they do not exist yet
for docker_log_file in \
    ${DOCKER_PATH}/logs/oscm-app/oscm-app.out.log \
    ${DOCKER_PATH}/logs/oscm-birt/oscm-birt.out.log \
    ${DOCKER_PATH}/logs/oscm-branding/oscm-branding.out.log \
    ${DOCKER_PATH}/logs/oscm-core/oscm-core.out.log \
    ${DOCKER_PATH}/logs/oscm-db/oscm-db.out.log; do
    if [ ! -f {docker_log_file} ]; then
        touch ${docker_log_file}
        chmod 640 ${docker_log_file}
    fi
done

# Create Docker Compose files from templates
envsubst '$DOCKER_PATH $IMAGE_DB $IMAGE_INITDB' \
< ${COMPOSE_CONFIG_PATH}/docker-compose-initdb.yml.template \
> ${TARGET_PATH}/docker-compose-initdb.yml
envsubst '$DOCKER_PATH $IMAGE_DB $IMAGE_CORE $IMAGE_APP $IMAGE_BIRT $IMAGE_BRANDING' \
< ${COMPOSE_CONFIG_PATH}/docker-compose-oscm.yml.template \
> ${TARGET_PATH}/docker-compose-oscm.yml
envsubst '$DOCKER_PATH $IMAGE_PROXY' \
< ${COMPOSE_CONFIG_PATH}/docker-compose-proxy.yml.template \
> ${TARGET_PATH}/docker-compose-proxy.yml

# If the user wants us to initialize the database, do it now
if [ ${INITDB} == "true" ]; then
    # If the Docker socket is not mounted, abort
    if [ ! -S /var/run/docker.sock ]; then
        echo "Docker socket is not mounted. Aborting."
        exit 1
    fi
    cd ${TARGET_PATH}
    docker-compose -f docker-compose-initdb.yml -p $(basename ${DOCKER_PATH}) up -d oscm-db
    docker-compose -f docker-compose-initdb.yml -p $(basename ${DOCKER_PATH}) up oscm-initdb-core
    docker-compose -f docker-compose-initdb.yml -p $(basename ${DOCKER_PATH}) up oscm-initdb-jms
    docker-compose -f docker-compose-initdb.yml -p $(basename ${DOCKER_PATH}) up oscm-initdb-app
    docker-compose -f docker-compose-initdb.yml -p $(basename ${DOCKER_PATH}) up oscm-initdb-controller-openstack
    docker-compose -f docker-compose-initdb.yml -p $(basename ${DOCKER_PATH}) up oscm-initdb-controller-aws
    docker-compose -f docker-compose-initdb.yml -p $(basename ${DOCKER_PATH}) stop
    docker-compose -f docker-compose-initdb.yml -p $(basename ${DOCKER_PATH}) rm -f
fi

# If the user wants us to start up the application, do it now
if [ ${STARTUP} == "true" ] && [ -S /var/run/docker.sock ]; then
    # If the Docker socket is not mounted, abort
    if [ ! -S /var/run/docker.sock ]; then
        echo "Docker socket is not mounted. Aborting."
        exit 1
    fi
    docker-compose -f docker-compose-oscm.yml -p $(basename ${DOCKER_PATH}) up -d
fi
