FROM sles12sp1

# prepare variable form build-args for further use
ARG ACTIVATION_CODE
ARG EMAIL_ADDRESS
ARG HTTP_PROXY
ARG HTTPS_PROXY

#set environmental variables
ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTPS_PROXY
ENV JAVA_HOME=/usr/lib64/jvm/java-1.8.0-openjdk

#register SLES
RUN SUSEConnect -r $ACTIVATION_CODE -e $EMAIL_ADDRESS

#check the status
RUN SUSEConnect -s

#install neccessary packages
RUN zypper -n in \
    java-1_8_0-openjdk \
    java-1_8_0-openjdk-devel
