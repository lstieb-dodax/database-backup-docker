#! /bin/bash

set -e

if [ -z "${S3_ACCESS_KEY_ID}" ] ; then
  printf "%s\n" "Warning: You did not set the S3_ACCESS_KEY_ID environment variable."
elif [ -z "${S3_SECRET_ACCESS_KEY}" ] ; then
  printf "%s\n" "Warning: You did not set the S3_SECRET_ACCESS_KEY environment variable."
elif [ -z "${S3_BUCKET}" ] ; then
  printf "%s\n" "You need to set the S3_BUCKET environment variable."
  exit 1
elif [ -z "${MONGO_CONFIGDB}" ] ; then
  printf "%s\n" "You need to set the MONGO_CONFIGDB environment variable."
  exit 1
elif [ -z "${MONGO_DATABASE}" ] ; then
  printf "%s\n" "You need to specify a database to dump."
  exit 1
fi

if [ "${S3_IAMROLE}" != "true" ] ; then
  export AWS_ACCESS_KEY_ID=${S3_ACCESS_KEY_ID}
  export AWS_SECRET_ACCESS_KEY=${S3_SECRET_ACCESS_KEY}
  export AWS_DEFAULT_REGION=${S3_REGION}
fi

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

printf "%s\n" "Starting up mongo router process, connecting with ${MONGO_CONFIGDB}"

mongos --configdb "${MONGO_CONFIGDB}" &

printf "%s\n" "Checking for database ${MONGO_DATABASE}"

#mongo --eval 'sh.status();' | grep "${MONGO_DATABASE}"

if [ $? != 0 ] ; then
  >&2 printf "%s\n" "Could not find database ${MONGO_DATABASE}."
  exit 1
fi

printf "%s\n" "Creating dump of ${MONGO_DATABASE} from ${MONGO_HOST}..."
DUMP_FILE="${DUMP_PATH}/${MONGO_DATABASE}.archive"
mongodump --db ${MONGO_DATABASE} --gzip --archive=$DUMP_FILE

if [ $? = 0 ] ; then
  printf "%s\n" "Dump created successfully, starting upload. Size: $(du -h $DUMP_FILE | awk '{print $1}')"
  S3_FILE="${DUMP_START_TIME}.${MONGO_DATABASE}.gz"
  copy_s3 "$DUMP_FILE" "$S3_FILE"
else
  >&2 printf "%s\n" "Error creating dump of ${MONGO_DATABASE}"
fi

printf "%s\n" "MongoDB backup finished"
rm -f "$DUMP_FILE"
