FROM phusion/baseimage:latest
MAINTAINER l.stiebellehner@dodax.com

ENV PROJECTNAME ""
ENV CASSANDRA_HOSTS ""
ENV CASSANDRA_USER ""
ENV CASSANDRA_PASSWORD ""
ENV S3_ACCESS_KEY_ID ""
ENV S3_SECRET_ACCESS_KEY ""
ENV S3_BUCKET ""
ENV S3_REGION eu-central-1
ENV SCHEDULE ""
ENV S3_ENCRYPTION "false"
ENV NEW_SNAPSHOT "false"

RUN apt-get update && apt-get -y install python-pip wget ca-certificates

RUN pip install awscli cassandra_snapshotter \
    && apt-get -y purge python-pip \
    && update-ca-certificates

RUN wget https://github.com/odise/go-cron/releases/download/v0.0.6/go-cron-linux.gz -O /usr/local/bin/go-cron.gz \
    && gunzip /usr/local/bin/go-cron.gz \
    && chmod u+x /usr/local/bin/go-cron \
    && apt-get -y purge wget ca-certificates \
    && apt-get -y autoremove

COPY entrypoint.sh entrypoint.sh
COPY backup.sh backup.sh

RUN chmod u+x entrypoint.sh backup.sh

CMD ["bash", "entrypoint.sh"]
