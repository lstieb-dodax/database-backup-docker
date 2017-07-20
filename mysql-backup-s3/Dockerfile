FROM alpine:latest
MAINTAINER l.stiebellehner@dodax.com

ENV PROJECTNAME ""
ENV MYSQLDUMP_OPTIONS "--quote-names --quick --add-drop-table --add-locks --allow-keywords --disable-keys --extended-insert --single-transaction --create-options --comments --net_buffer_length=16384"
ENV MYSQLDUMP_DATABASE ""
ENV DUMP_PATH "/tmp"
ENV MYSQL_HOST ""
ENV MYSQL_PORT 3306
ENV MYSQL_USER ""
ENV MYSQL_PASSWORD ""
ENV S3_ACCESS_KEY_ID ""
ENV S3_SECRET_ACCESS_KEY ""
ENV S3_BUCKET ""
ENV S3_REGION eu-central-1
ENV SCHEDULE ""

RUN apk add --no-cache bash mysql-client python py-pip wget ca-certificates

RUN pip install awscli \
    && apk del py-pip \
    && update-ca-certificates

RUN wget https://github.com/odise/go-cron/releases/download/v0.0.6/go-cron-linux.gz -O /usr/local/bin/go-cron.gz \
    && gunzip /usr/local/bin/go-cron.gz \
    && chmod u+x /usr/local/bin/go-cron \
    && apk del wget ca-certificates \
    && rm -rf /var/cache/apk/*

COPY entrypoint.sh entrypoint.sh
COPY backup.sh backup.sh

RUN chmod u+x entrypoint.sh backup.sh

CMD ["bash", "entrypoint.sh"]
