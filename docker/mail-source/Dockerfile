FROM java:8
VOLUME /tmp
ADD mail-source-kafka-10-1.2.0.RELEASE.jar app.jar
RUN bash -c 'touch /app.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar", "--server.host=8181", "--spring.cloud.stream.bindings.output.destination=processemail", "--spring.cloud.stream.kafka.binder.zkNodes=${ZOOKEEPER_HOST}", "--spring.cloud.stream.kafka.binder.brokers=${KAFKA_HOST}", "--mail.url=imaps://${IF_EMAIL_ID}:${IF_EMAIL_CREDS}@imap.gmail.com/INBOX"]