FROM oscm-sles-based

ENV HOST_FQDN=localhost
$IMAGE_DB $DB_VOLUME_DATA_SRC $IMAGE_INITDB


COPY templates/env.template templates/var.env.template templates/docker-compose-initdb.yml.template templates/docker-compose-oscm.yml.template start.sh /opt/

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTPS_PROXY && \
    zypper -n in gettext-runtime vim && \
    zypper clean && \
    SUSEConnect --cleanup && \
    if [ -f /etc/SUSEConnect ]; then rm -f /etc/SUSEConnect; fi && \
    if [ -d /etc/zypp/services.d ]; then rm -f /etc/zypp/services.d/*; fi && \
    if [ -d /etc/zypp/credentials.d ]; then rm -f /etc/zypp/credentials.d/*; fi \
    chmod +x /opt/start.sh && \

VOLUME /target

CMD ["/opt/start.sh"]
