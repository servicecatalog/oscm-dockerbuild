FROM centos:7

RUN yum -y install java-1.7.0-openjdk java-1.7.0-openjdk-devel unzip wget && \
    wget http://download.java.net/glassfish/3.1.2/release/glassfish-3.1.2.zip -O /tmp/glassfish.zip && \
	wget https://www.bouncycastle.org/download/bcprov-jdk15on-156.jar -O /usr/lib/jvm/jre/lib/ext/bcprov.jar && \
	echo "security.provider.10=org.bouncycastle.jce.provider.BouncyCastleProvider" >> /usr/lib/jvm/jre/lib/security/java.security && \
    unzip /tmp/glassfish.zip -d /opt/ && \
	rm -rf /opt/glassfish3/glassfish/domains/domain1 && \
       rm /tmp/glassfish.zip && \
       mkdir /opt/jks && \
       mkdir /opt/jks/mi && \
       mkdir /opt/jks/bes && \
       mkdir /opt/jks/app && \
       cp /opt/glassfish3/glassfish/lib/templates/cacerts.jks /opt/jks/mi/cacerts.jks_mi && \
       cp /opt/glassfish3/glassfish/lib/templates/cacerts.jks /opt/jks/bes/cacerts.jks_bes && \
       cp /opt/glassfish3/glassfish/lib/templates/cacerts.jks /opt/jks/app/cacerts.jks_app && \
       /bin/keytool -genkeypair keyalg RSA -keysize 2048 -sigalg SHA256withRSA -alias s1as -dname "CN=oscm-bes" -keypass changeit -validity 3650 -keystore /opt/jks/mi/keystore.jks_mi -storepass changeit && \
       /bin/keytool -genkeypair keyalg RSA -keysize 2048 -sigalg SHA256withRSA -alias s1as -dname "CN=oscm-bes" -keypass changeit -validity 3650 -keystore /opt/jks/bes/keystore.jks_bes -storepass changeit && \
       /bin/keytool -genkeypair keyalg RSA -keysize 2048 -sigalg SHA256withRSA -alias s1as -dname "CN=oscm-app" -keypass changeit -validity 3650 -keystore /opt/jks/app/keystore.jks_app -storepass changeit && \
       /bin/keytool -exportcert -alias s1as -file /opt/jks/mi/s1as.crt_mi -keystore /opt/jks/mi/keystore.jks_mi -storepass changeit && \
       /bin/keytool -exportcert -alias s1as -file /opt/jks/bes/s1as.crt_bes -keystore /opt/jks/bes/keystore.jks_bes -storepass changeit && \
       /bin/keytool -exportcert -alias s1as -file /opt/jks/app/s1as.crt_app -keystore /opt/jks/app/keystore.jks_app -storepass changeit && \
       /bin/keytool -importcert -alias s1as -file /opt/jks/mi/s1as.crt_mi -keystore /opt/jks/mi/cacerts.jks_mi -storepass changeit -noprompt && \
       /bin/keytool -importcert -alias s1as -file /opt/jks/bes/s1as.crt_bes -keystore /opt/jks/bes/cacerts.jks_bes -storepass changeit -noprompt && \
       /bin/keytool -importcert -alias s1as -file /opt/jks/app/s1as.crt_app -keystore /opt/jks/app/cacerts.jks_app -storepass changeit -noprompt && \
       /bin/keytool -importcert -alias bes-s1as -file /opt/jks/bes/s1as.crt_bes -keystore /opt/jks/app/cacerts.jks_app -storepass changeit -noprompt && \
       /bin/keytool -importcert -alias app-s1as -file /opt/jks/app/s1as.crt_app -keystore /opt/jks/bes/cacerts.jks_bes -storepass changeit -noprompt

COPY postgresql-9.1-903.jdbc4.jar /opt/glassfish3/glassfish/lib/
