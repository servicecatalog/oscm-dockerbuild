 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2020                                            *
 #*                                                                           *
 #* Creation Date: 30-09-2020                                                 *
 #*                                                                           *
 #*****************************************************************************

FROM oscm-centos-based

ARG SASS_VERSION='1.26.11'
ARG SASS_BINARY="dart-sass-${SASS_VERSION}-linux-x64.tar.gz"

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    yum update -y && \
    yum install -y wget zip unzip git && \
    wget "https://github.com/sass/dart-sass/releases/download/${SASS_VERSION}/${SASS_BINARY}" -O /tmp/"${SASS_BINARY}" && \
    tar -C /usr/local -xzf /tmp/"${SASS_BINARY}"

ENV SASS_PATH=/usr/local/dart-sass
RUN echo "export PATH=${PATH}:${SASS_PATH}" >> ~/.bashrc

ENTRYPOINT ["/usr/local/dart-sass"]