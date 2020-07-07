FROM oscm-centos-based

ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTP_PROXY
ENV MANPATH=/opt/rh/rh-ruby26/root/usr/local/share/man:/opt/rh/rh-ruby26/root/usr/share/man:
ENV LD_LIBRARY_PATH=/opt/rh/rh-ruby26/root/usr/local/lib64:/opt/rh/rh-ruby26/root/usr/lib64
ENV PATH=/opt/rh/rh-ruby26/root/usr/local/bin:/opt/rh/rh-ruby26/root/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV XDG_DATA_DIRS=/opt/rh/rh-ruby26/root/usr/local/share:/opt/rh/rh-ruby26/root/usr/share:/usr/local/share:/usr/share
ENV PKG_CONFIG_PATH=/opt/rh/rh-ruby26/root/usr/local/lib64/pkgconfig:/opt/rh/rh-ruby26/root/usr/lib64/pkgconfig
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8


RUN yum update -y && \
	yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum install -y \
    rh-ruby26 \
    ruby-devel \
    libpng-devel \
    rh-ruby26-ruby-devel.x86_64 && \
    yum groupinstall -y Development Tools && \
    yum -y makecache fast 
    
    
RUN scl enable rh-ruby26 bash

RUN /bin/bash -l -c "/opt/rh/rh-ruby26/root/usr/bin/gem install bundler" && \
    /bin/bash -l -c "/opt/rh/rh-ruby26/root/usr/bin/gem install bootstrap -v 4.3.1" && \
    /bin/bash -l -c "/opt/rh/rh-ruby26/root/usr/bin/gem install sass -v 3.7.4 "

ENTRYPOINT ["/opt/rh/rh-ruby26/root/usr/local/share/gems/gems/sass-3.7.4/bin/sass"]
