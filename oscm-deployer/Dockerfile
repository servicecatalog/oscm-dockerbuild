FROM oscm-sles-based
# FROM centos:7

ENV INITDB=false
ENV STARTUP=false
ENV SYSLOG=false
ENV SAMPLE_DATA=false
ENV HOST_FQDN=localhost
ENV IMAGE_DB=oscm-db:latest
ENV IMAGE_CORE=oscm-core:latest
ENV IMAGE_APP=oscm-app:latest
ENV IMAGE_BIRT=oscm-birt:latest
ENV IMAGE_BRANDING=oscm-branding:latest
ENV IMAGE_INITDB=oscm-initdb:latest
ENV IMAGE_PROXY=oscm-proxy:latest
ENV TARGET_PATH=/target

COPY templates/env.template templates/var.env.template templates/docker-compose-initdb.yml.template templates/docker-compose-oscm.yml.template templates/docker-compose-oscm-syslog.yml.template templates/docker-compose-proxy.yml.template start.sh /opt/

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTPS_PROXY && \
    SUSEConnect -p sle-module-containers/12/x86_64 -r '' && \
    zypper -n in gettext-runtime vim docker && \
    zypper clean && \
    SUSEConnect --cleanup && \
    curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    chmod +x /opt/start.sh && \
    if [ -f /etc/SUSEConnect ]; then rm -f /etc/SUSEConnect; fi && \
    if [ -d /etc/zypp/services.d ]; then rm -f /etc/zypp/services.d/*; fi && \
    if [ -d /etc/zypp/credentials.d ]; then rm -f /etc/zypp/credentials.d/*; fi

# RUN yum -y update && \
#     yum -y install gettext docker-client && \
#     curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
#     chmod +x /usr/local/bin/docker-compose && \
#     chmod +x /opt/start.sh

VOLUME /target

CMD ["/opt/start.sh"]
