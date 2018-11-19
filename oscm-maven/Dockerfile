FROM oscm-sles-based

RUN export http_proxy=$HTTP_PROXY && \
    export https_proxy=$HTTPS_PROXY && \
	zypper -n in tar which java-1_8_0-openjdk java-1_8_0-openjdk-devel && \
	zypper clean && \
	SUSEConnect --cleanup

RUN mkdir -p /usr/share/maven /usr/share/maven/ref && \
    curl -fsSL -o /tmp/apache-maven.tar.gz https://apache.osuosl.org/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz && \
    tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 && \
    rm -f /tmp/apache-maven.tar.gz && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

RUN groupadd jenkins && \
    useradd -ms /bin/bash jenkins -g jenkins

ENV JAVA_HOME /usr/lib64/jvm/java-1.8.0-openjdk
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "/root/.m2"

ENTRYPOINT ["/usr/bin/mvn"]
