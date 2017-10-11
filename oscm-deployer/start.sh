#!/bin/bash
# If /target/var.env does not exist, just copy the template for the operator and exit
if [ ! -f /target/var.env ]; then
    cp /opt/var.env.template /target/var.env
else
    # Enable command traces
    set -x
    # Exit on error
    set -e
    
    # Variables for this script
    COMPOSE_CONFIG_PATH=/opt
    DOCKER_PATH=/target
    # Enable automatic exporting of variables
    set -a
    # Read configuration files
    source ${CONFIG_PATH}/heat-config
    source ${CONFIG_PATH}/oscm-config
    # Disable automatic exporting of variables
    set +a
    
    # Create Docker directories if they do not exist yet
    for docker_directory in \
        ${DOCKER_PATH}/data/oscm-db/data \
        ${DOCKER_PATH}/config/brandings\
        ${DOCKER_PATH}/config/certs \
        ${DOCKER_PATH}/config/privkey/oscm-core \
        ${DOCKER_PATH}/config/privkey/oscm-app \
        ${DOCKER_PATH}/config/privkey/oscm-birt \
        ${DOCKER_PATH}/config/privkey/oscm-branding \
        ${DOCKER_PATH}/logs/oscm-app \
        ${DOCKER_PATH}/logs/oscm-birt \
        ${DOCKER_PATH}/logs/oscm-branding \
        ${DOCKER_PATH}/logs/oscm-core \
        ${DOCKER_PATH}/logs/oscm-db; do
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
    envsubst '$IMAGE_DB $DB_VOLUME_DATA_SRC $IMAGE_INITDB' \
    < ${COMPOSE_CONFIG_PATH}/docker-compose-initdb.yml.template \
    > ${DOCKER_PATH}/docker-compose-initdb.yml
    envsubst '$IMAGE_DB $DB_VOLUME_DATA_SRC $DB_PORT $IMAGE_CORE $IMAGE_APP $IMAGE_BIRT $IMAGE_BRANDING $BRANDING_VOLUME_BRANDINGS_SRC' \
    < ${COMPOSE_CONFIG_PATH}/docker-compose-oscm.yml.template \
    > ${DOCKER_PATH}/docker-compose-oscm.yml
    envsubst '$IMAGE_PROXY' \
    < ${COMPOSE_CONFIG_PATH}/docker-compose-proxy.yml.template \
    > ${DOCKER_PATH}/docker-compose-proxy.yml
fi
