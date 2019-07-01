FROM oscm-centos-based

COPY ssl.crt /opt/ssl.crt
COPY ssl.key /opt/ssl.key
COPY ssl.crt /usr/share/pki/ca-trust-source/anchors

RUN mkdir /opt/identity/ && \
	mkdir /opt/identity/config/tenants
	
 
RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTP_PROXY && \
    yum install -y \
    	tar \
        which \
        java-1.8.0-openjdk \
        java-1.8.0-openjdk-devel && \
    yum clean all

ENV http_proxy=$HTTP_PROXY
ENV https_proxy=$HTTP_PROXY

 

COPY oscm-identity.jar /opt/identity/main.jar
COPY start.sh /opt/identity/start.sh
 
RUN chmod +x /opt/identity/start.sh

CMD ["/opt/identity/start.sh"]


