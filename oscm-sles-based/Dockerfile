FROM sles12sp1

# prepare variable form build-args for further use
ARG ACTIVATION_CODE
ARG EMAIL_ADDRESS
ARG HTTP_PROXY
ARG HTTPS_PROXY

#set environmental variables
ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTPS_PROXY

#register SLES
RUN SUSEConnect -r $ACTIVATION_CODE -e $EMAIL_ADDRESS

#check the status
RUN SUSEConnect -s

