FROM nginx:mainline

ENV BRANDING_DIR=/brandings GS_SERVICE_ACCOUNT_KEY_FILE=/key/keyfile.json GS_BUCKET=mybucket

COPY start.sh /opt/start.sh

RUN chmod +x /opt/start.sh && \
    rm /usr/share/nginx/html/index.html && \
    sed -i 's|deb\.debian\.org|ftp2.de.debian.org|g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install lsb-release curl gnupg apt-transport-https && \
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && \
    apt-get -y install google-cloud-sdk && \
    apt-get -y autoremove && \
    apt-get clean
    

EXPOSE 80 443

CMD ["/opt/start.sh"]
