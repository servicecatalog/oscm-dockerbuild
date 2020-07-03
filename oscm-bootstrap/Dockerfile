FROM oscm-centos-based

ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTP_PROXY

RUN yum update -y && \
	yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum install -y \
    rh-ruby26 \
    ruby-devel \
    postgresql-devel \
    gcc \
    libpng-devel \
    rh-ruby26-ruby-devel.x86_64 && \
    yum groupinstall -y Development Tools && \
    yum -y makecache fast && \
    scl enable rh-ruby26 bash && \
    gem update --system && \
    gem install bundler && \
    gem install bootstrap -v 4.3.1 && \
    gem install sass -v 3.7.4 && \
    sass /opt/rh/rh-ruby26/root/usr/local/share/gems/gems/bootstrap-4.3.1/assets/stylesheets/*.scss
    
    

ENTRYPOINT ["/opt/rh/rh-ruby26/root/usr/local/share/gems/gems/sass-3.7.4/bin/sass"]
