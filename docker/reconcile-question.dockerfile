FROM java:8
VOLUME /tmp
ADD jdbc-sink-kafka-10-1.2.0.RELEASE.jar app.jar
RUN bash -c 'touch /app.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar", "--server.host=0", "--spring.cloud.stream.bindings.output.destination=processemail", "--spring.cloud.stream.kafka.binder.zkNodes=${ZOOKEEPER_HOST}", "--spring.cloud.stream.kafka.binder.brokers=${KAFKA_HOST}", "--spring.datasource.url=jdbc:mysql://${DB_HOST}:${IF_DB_PORT}/ideafoundry?user=ideafoundry", "--spring.datasource.password=${IF_DB_PASSWORD}", "--spring.datasource.driver-class-name=org.mariadb.jdbc.Driver", "--jdbc.table-name=reconcile_question", "--jdbc.columns=id,record_id,question,answer"]