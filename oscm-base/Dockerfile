FROM sles12sp1

ENV http_proxy $http_proxy
ENV https_proxy $https_proxy

ARG ACTIVATION_CODE
ARG EMAIL_ADDRESS

RUN echo $http_proxy
RUN SUSEConnect -s