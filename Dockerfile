FROM lwieske/java-8

RUN adduser -D demo demo

ENV DERBY_HOME=/opt/derby
ENV DERBY_LIB=${DERBY_HOME}/lib
ENV CLASSPATH=${DERBY_LIB}/derby.jar:${DERBY_LIB}/derbynet.jar:${DERBY_LIB}/derbytools.jar:${DERBY_LIB}/derbyoptionaltools.jar:${DERBY_LIB}/derbyclient.jar

RUN mkdir -p /opt/derby/lib

COPY target/derby-db-service-*-libs.tar.gz /opt/derby/tmp/derby-db-service-libs.tar.gz

RUN tar -xzf /opt/derby/tmp/derby-db-service-libs.tar.gz -C /opt/derby/lib

RUN rm -rf /opt/derby/tmp

RUN mkdir -p /database

RUN chown -R demo:demo /opt/derby /database

USER demo

WORKDIR /opt/derby/lib

EXPOSE 1527

ENTRYPOINT java -Dderby.system.home=/database org.apache.derby.drda.NetworkServerControl start -p 1527 -h 0.0.0.0
