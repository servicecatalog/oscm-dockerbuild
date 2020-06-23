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

COPY templates/env.template templates/var.env.template templates/var.env.withoutSampleData.template templates/docker-compose-initdb.yml.template templates/docker-compose-oscm.yml.template templates/docker-compose-oscm-syslog.yml.template templates/docker-compose-proxy.yml.template resources/proxy.conf.template resources/index.html.template start.sh /opt/
COPY resources/tenant-default.properties /opt/tenant-default.properties
RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    yum -y update && \
    yum -y install vim \
           docker-client && \
    yum clean all && \
    curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    chmod +x /opt/start.sh

VOLUME /target

CMD ["/opt/start.sh"]

