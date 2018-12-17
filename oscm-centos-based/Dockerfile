FROM centos:7

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    yum update -y && \
    yum install -y https://centos7.iuscommunity.org/ius-release.rpm && \
    yum makecache fast && \
    yum install -y \
        python36u-pip \
        unzip \
        wget \
        openssl \
        tcpdump \
        gettext && \
    yum clean all
