FROM oscm-centos-based

COPY ssl.crt /opt/ssl.crt
COPY ssl.key /opt/ssl.key
COPY ssl.crt /usr/share/pki/ca-trust-source/anchors

COPY oscm-identity.jar /opt/main.jar

COPY start.sh /opt/

RUN chmod +x /opt/start.sh

CMD ["/opt/start.sh"]


