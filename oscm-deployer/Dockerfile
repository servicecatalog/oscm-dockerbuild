 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2020                                            *
 #*                                                                           *
 #* Creation Date: 16-07-2020                                                 *
 #*                                                                           *
 #*****************************************************************************

FROM oscm-centos-based

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
ENV IMAGE_IDENTITY=oscm-identity:latest
ENV IMAGE_PROXY=oscm-proxy:latest
ENV TARGET_PATH=/target

COPY templates/env.template templates/var.env.template templates/var.env.withoutSampleData.template templates/docker-compose-initdb.yml.template templates/docker-compose-oscm.yml.template templates/docker-compose-oscm-syslog.yml.template templates/docker-compose-proxy.yml.template resources/proxy.conf.template resources/index.html.template resources/oscm-upload-branding.sh start.sh /opt/
COPY resources/tenant-default.properties /opt/tenant-default.properties
RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    yum -y update && \
    yum -y install vim \
           docker-client \
           dos2unix && \
    yum clean all && \
    curl -L https://github.com/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    chmod +x /opt/start.sh && \
    dos2unix /opt/env.template /opt/var.env.template /opt/var.env.withoutSampleData.template /opt/docker-compose-initdb.yml.template /opt/docker-compose-oscm.yml.template /opt/docker-compose-oscm-syslog.yml.template /opt/docker-compose-proxy.yml.template /opt/proxy.conf.template /opt/start.sh && \
    yum -y remove dos2unix

VOLUME /target

CMD ["/opt/start.sh"]

