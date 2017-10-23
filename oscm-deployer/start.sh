#!/bin/bash
# Variables for this script
COMPOSE_CONFIG_PATH=/opt
TARGET_PATH=/target

# If ${TARGET_PATH}/var.env does not exist, just copy the template for the operator and exit
if [ ! -f ${TARGET_PATH}/var.env ] || [ ! -f ${TARGET_PATH}/.env ]; then
    cp /opt/env.template ${TARGET_PATH}/.env
    cp /opt/var.env.template ${TARGET_PATH}/var.env
else
    # Enable command traces
    set -x
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
fi
