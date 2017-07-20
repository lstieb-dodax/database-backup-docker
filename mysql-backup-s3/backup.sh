#! /bin/bash

set -e

if [ -z "${S3_ACCESS_KEY_ID}" ] ; then
  printf "%s\n" "Warning: You did not set the S3_ACCESS_KEY_ID environment variable."
elif [ -z "${S3_SECRET_ACCESS_KEY}" ] ; then
  printf "%s\n" "Warning: You did not set the S3_SECRET_ACCESS_KEY environment variable."
elif [ -z "${S3_BUCKET}" ] ; then
  printf "%s\n" "You need to set the S3_BUCKET environment variable."
  exit 1
elif [ -z "${MYSQL_HOST}" ] ; then
  printf "%s\n" "You need to set the MYSQL_HOST environment variable."
  exit 1
elif [ -z "${MYSQL_USER}" ] ; then
  printf "%s\n" "You need to set the MYSQL_USER environment variable."
  exit 1
elif [ -z "${MYSQLDUMP_DATABASE}" ] ; then
  printf "%s\n" "You need to specify a database to dump."
  exit 1
elif [ -z "${MYSQL_PASSWORD}" ] ; then
  printf "%s\n" "You need to set the MYSQL_PASSWORD environment variable or link to a container named MYSQL."
  exit 1
fi

if [ "${S3_IAMROLE}" != "true" ] ; then
  export AWS_ACCESS_KEY_ID=${S3_ACCESS_KEY_ID}
  export AWS_SECRET_ACCESS_KEY=${S3_SECRET_ACCESS_KEY}
  export AWS_DEFAULT_REGION=${S3_REGION}
fi

MYSQL_HOST_OPTS="-h $MYSQL_HOST -P $MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD"
DUMP_START_TIME=$(date +"%Y-%m-%dT%H%M%SZ")

copy_s3 () {
  SRC_FILE=$1
  DEST_FILE=$2

  printf "%s\n" "Uploading ${DEST_FILE} to S3..."
  if ! aws s3 cp "$SRC_FILE" "s3://$S3_BUCKET/$PROJECTNAME/$DEST_FILE" ; then
    >&2 printf "%s\n" "Error uploading ${DEST_FILE} on S3"
  fi
  rm "$SRC_FILE"
}

printf "%s\n" "Creating dump of ${MYSQLDUMP_DATABASE} from ${MYSQL_HOST}..."
DUMP_FILE="${DUMP_PATH}/${MYSQLDUMP_DATABASE}.sql.gz"
mysqldump $MYSQL_HOST_OPTS $MYSQLDUMP_OPTIONS --databases $MYSQLDUMP_DATABASE | gzip > $DUMP_FILE
if [ $? = 0 ] ; then
  S3_FILE="${DUMP_START_TIME}.${MYSQLDUMP_DATABASE}.sql.gz"
  copy_s3 "$DUMP_FILE" "$S3_FILE"
else
  >&2 printf "%s\n" "Error creating dump of ${MYSQLDUMP_DATABASE}"
fi

printf "%s\n" "SQL backup finished"
rm -f "$DUMP_FILE"
