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
COPY resources/compile_branding_packages.sh /opt/
COPY ssl.crt /opt/ssl.crt
COPY ssl.key /opt/ssl.key
COPY ssl.crt /usr/share/pki/ca-trust-source/anchors/\

ARG SASS_VERSION='1.26.11'
ARG YUI_VERSION='2.4.7'
ARG SASS_BINARY="dart-sass-${SASS_VERSION}-linux-x64.tar.gz"
ARG SASS_PATH=/usr/local/dart-sass

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    yum install -y \
        tar && \
    yum clean all && \
    wget "https://github.com/sass/dart-sass/releases/download/${SASS_VERSION}/${SASS_BINARY}" -O /tmp/"${SASS_BINARY}" && \
    wget "https://repo1.maven.org/maven2/com/yahoo/platform/yui/yuicompressor/${YUI_VERSION}/yuicompressor-${YUI_VERSION}.jar" -O /usr/local && \
    tar -C /usr/local -xzf /tmp/"${SASS_BINARY}" && \
    chmod +x /opt/start.sh

ENV PATH "$PATH:${SASS_PATH}"
EXPOSE 80 443

CMD ["/opt/start.sh"]

