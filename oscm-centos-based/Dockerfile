 #*****************************************************************************
 #*                                                                           *
 #* Copyright FUJITSU LIMITED 2020                                            *
 #*                                                                           *
 #* Creation Date: 16-07-2020                                                 *
 #*                                                                           *
 #*****************************************************************************

FROM centos:7

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    yum update -y && \
    yum install -y \
        centos-release-scl \
        rh-python36 \
        unzip \
        wget \
        openssl \
        tcpdump \
        gettext && \
    yum makecache fast && \
    yum clean all
    