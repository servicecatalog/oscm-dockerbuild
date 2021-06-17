#*****************************************************************************
#*                                                                           *
#* Copyright FUJITSU LIMITED 2021                                           *
#*                                                                           *
#* Creation Date: 17-03-2021                                                 *
#*                                                                           *
#*****************************************************************************

FROM oscm-centos-based

COPY ssl.crt /opt/ssl.crt
COPY ssl.key /opt/ssl.key
COPY ssl.crt /usr/share/pki/ca-trust-source/anchors

RUN mkdir /opt/mail && \
    mkdir /opt/mail/config && \
    mkdir /opt/certs && \
    export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    yum install -y \
      tar \
      which \
      java-1.8.0-openjdk \
      java-1.8.0-openjdk-devel && \
    yum clean all

COPY oscm-mail.jar /opt/mail/main.jar
COPY start.sh /opt/mail/start.sh

RUN chmod +x /opt/mail/start.sh

CMD ["/opt/mail/start.sh"]
