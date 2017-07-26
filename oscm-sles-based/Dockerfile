FROM sles12sp1:latest

# register SLES
# ATTENTION: In all final images do not forget to deregister SLES with
# SUSEConnect -d
RUN export no_proxy=$(echo $ACTIVATION_CODE_URL | awk -F'/' '{print $3}' | ^Ct -d':' -f1) && \
    SUSEConnect -r $(curl --silent ${ACTIVATION_CODE_URL} | tr -d '\n') -e ${EMAIL_ADDRESS} && \
    unset no_proxy
