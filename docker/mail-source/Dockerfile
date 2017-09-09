FROM java:8
VOLUME /tmp
ADD mail-source-kafka-10-1.2.0.RELEASE.jar app.jar
RUN bash -c 'touch /app.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar", "--spring.cloud.stream.bindings.output.destination=processemail", "--spring.cloud.stream.kafka.binder.zkNodes=${HOST_IP}", "--spring.cloud.stream.kafka.binder.brokers=${HOST_IP}", "--mail.url=imaps://${IF_EMAIL_ID}:${IF_EMAIL_CREDS}@imap.gmail.com/INBOX"]