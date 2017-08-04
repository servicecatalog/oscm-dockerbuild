FROM oscm-nginx

ENV SOURCE=LOCAL BRANDING_DIR=/brandings GS_SERVICE_ACCOUNT_KEY_FILE=/key/keyfile.json GS_BUCKET=mybucket

COPY start.sh /opt/start.sh
COPY resources/brandings.conf /etc/nginx/vhosts.d/

# Attention: google-cloud-sdk broken; python-Jinja2 not available for SLE_12_SP1
# RUN zypper addrepo http://download.opensuse.org/repositories/Cloud:Tools/SLE_12_SP1/Cloud:Tools.repo && \
#     zypper --gpg-auto-import-keys refresh && \
#     zypper install -y tar google-cloud-sdk && \
#     zypper clean && \
#     chmod +x /opt/start.sh && \
#     SUSEConnect -d

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTPS_PROXY && \
    zypper install -y tar && \
    zypper clean && \
    chmod +x /opt/start.sh && \
    SUSEConnect --cleanup && \
    if [ -f /etc/SUSEConnect ]; then rm -f /etc/SUSEConnect; fi && \
    if [ -d /etc/zypp/services.d ]; then rm -f /etc/zypp/services.d/*; fi && \
    if [ -d /etc/zypp/credentials.d ]; then rm -f /etc/zypp/credentials.d/*; fi

EXPOSE 80 443

CMD ["/opt/start.sh"]
