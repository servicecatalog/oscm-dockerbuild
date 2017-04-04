FROM centos:7

RUN yum -y install java-1.7.0-openjdk java-1.7.0-openjdk-devel unzip wget && \
    wget http://download.java.net/glassfish/3.1.2/release/glassfish-3.1.2.zip -O /tmp/glassfish.zip && \
	wget https://www.bouncycastle.org/download/bcprov-jdk15on-156.jar -O /usr/lib/jvm/jre/lib/ext/bcprov.jar && \
	echo "security.provider.10=org.bouncycastle.jce.provider.BouncyCastleProvider" >> /usr/lib/jvm/jre/lib/security/java.security && \
    unzip /tmp/glassfish.zip -d /opt/ && \
	rm -rf /opt/glassfish3/glassfish/domains/domain1 && \
       rm /tmp/glassfish.zip && \
       mkdir /opt/jks && \
       cp /opt/glassfish3/glassfish/lib/templates/cacerts.jks /opt/jks/cacerts.jks_mi && \
       cp /opt/glassfish3/glassfish/lib/templates/cacerts.jks /opt/jks/cacerts.jks_bes && \
       cp /opt/glassfish3/glassfish/lib/templates/cacerts.jks /opt/jks/cacerts.jks_app && \
       /bin/keytool -genkeypair -alias s1as -dname "CN=oscm-bes" -keypass changeit -validity 3650 -keystore /opt/jks/keystore.jks_mi -storepass changeit && \
       /bin/keytool -genkeypair -alias s1as -dname "CN=oscm-bes" -keypass changeit -validity 3650 -keystore /opt/jks/keystore.jks_bes -storepass changeit && \
       /bin/keytool -genkeypair -alias s1as -dname "CN=oscm-app" -keypass changeit -validity 3650 -keystore /opt/jks/keystore.jks_app -storepass changeit && \
       /bin/keytool -exportcert -alias s1as -file /opt/jks/s1as.crt_mi -keystore /opt/jks/keystore.jks_mi -storepass changeit && \
       /bin/keytool -exportcert -alias s1as -file /opt/jks/s1as.crt_bes -keystore /opt/jks/keystore.jks_bes -storepass changeit && \
       /bin/keytool -exportcert -alias s1as -file /opt/jks/s1as.crt_app -keystore /opt/jks/keystore.jks_app -storepass changeit && \
       /bin/keytool -importcert -alias s1as -file /opt/jks/s1as.crt_mi -keystore /opt/jks/cacerts.jks_mi -storepass changeit -noprompt && \
       /bin/keytool -importcert -alias s1as -file /opt/jks/s1as.crt_bes -keystore /opt/jks/cacerts.jks_bes -storepass changeit -noprompt && \
       /bin/keytool -importcert -alias s1as -file /opt/jks/s1as.crt_app -keystore /opt/jks/cacerts.jks_app -storepass changeit -noprompt && \
       /bin/keytool -importcert -alias bes-s1as -file /opt/jks/s1as.crt_bes -keystore /opt/jks/cacerts.jks_app -storepass changeit -noprompt && \
       /bin/keytool -importcert -alias app-s1as -file /opt/jks/s1as.crt_app -keystore /opt/jks/cacerts.jks_bes -storepass changeit -noprompt && \
       rm -f /opt/jks/s1as.crt_*

COPY postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/lib/
