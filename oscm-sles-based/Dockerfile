FROM centos:latest

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    yum update -y && \
    yum install -y \
        unzip \
        wget \
        openssl
        gettext && \
    yum clean all
