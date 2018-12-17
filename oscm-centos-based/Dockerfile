FROM centos:7

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    yum update -y && \
    yum install -y centos-release-scl \
    yum makecache fast && \
    yum install -y \
        rh-python36 \
        unzip \
        wget \
        openssl \
        tcpdump \
        gettext && \
    yum clean all
    