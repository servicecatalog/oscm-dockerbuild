FROM centos:7
MAINTAINER Robert Miethaner <robert.miethaner@est.fujitsu.com>
MAINTAINER Frank Shimizu <frank.shimizu@est.fujitsu.com>

# Update the OS
RUN  export http_proxy && \
     export https_proxy && \
     yum clean all && \
     yum update -y && \
     yum clean all

# Add nginx yum repository
COPY nginx.repo /etc/yum.repos.d/

# Install nginx
RUN  curl http://nginx.org/keys/nginx_signing.key -o /tmp/nginx_signing.key && \
     rpm --import /tmp/nginx_signing.key && \
     yum install -y nginx && \
     yum clean all

# Expose ports
EXPOSE 80 443

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
