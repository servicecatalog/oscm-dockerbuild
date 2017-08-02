FROM sles12sp1:latest

# prepare variable form build-args for further use
ARG ACTIVATION_CODE_URL
ARG EMAIL_ADDRESS

# register SLES
# ATTENTION: In all final images do not forget to deregister SLES with
# SUSEConnect -d

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTPS_PROXY && \
    SUSEConnect -r $(curl --silent --noproxy $(echo ${ACTIVATION_CODE_URL} | awk -F'/' '{print $3}' | cut -d':' -f1) ${ACTIVATION_CODE_URL}) -e ${EMAIL_ADDRESS} && \
    zypper update -y && \
    zypper install -y \
        unzip \
        wget && \
    zypper clean -a
