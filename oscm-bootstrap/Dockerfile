FROM oscm-centos-based

ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTP_PROXY
ENV gem_home /opt/rh/rh-ruby26/root/usr/bin/gem

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

RUN /bin/bash -l -c "gem install bundler" && \
    /bin/bash -l -c "gem install bootstrap -v 4.3.1" && \
    /bin/bash -l -c "gem install sass -v 3.7.4 "
    
RUN /bin/bash -l -c "gem update --system"


RUN sass /opt/rh/rh-ruby26/root/usr/local/share/gems/gems/bootstrap-4.3.1/assets/stylesheets/*.scss

ENTRYPOINT ["/opt/rh/rh-ruby26/root/usr/local/share/gems/gems/sass-3.7.4/bin/sass"]
