 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2020                                            *
 #*                                                                           *
 #* Creation Date: 16-07-2020                                                 *
 #*                                                                           *
 #*****************************************************************************

FROM oscm-nginx

ENV SOURCE=LOCAL BRANDING_DIR=/import/brandings GS_SERVICE_ACCOUNT_KEY_FILE=/key/keyfile.json GS_BUCKET=mybucket

COPY start.sh /opt/start.sh
COPY resources/brandings.conf /etc/nginx/vhosts.d/
COPY ssl.crt /opt/ssl.crt
COPY ssl.key /opt/ssl.key
COPY ssl.crt /usr/share/pki/ca-trust-source/anchors/

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    yum install -y --no-install-recommends \
        tar \
    yum clean all && \
    chmod +x /opt/start.sh

EXPOSE 80 443

CMD ["/opt/start.sh"]

