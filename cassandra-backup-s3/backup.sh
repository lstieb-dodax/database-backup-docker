#! /bin/bash

set -e

if [ -z "${S3_ACCESS_KEY_ID}" ] ; then
  printf "%s\n" "Warning: You did not set the S3_ACCESS_KEY_ID environment variable."
elif [ -z "${S3_SECRET_ACCESS_KEY}" ] ; then
  printf "%s\n" "Warning: You did not set the S3_SECRET_ACCESS_KEY environment variable."
elif [ -z "${S3_BUCKET}" ] ; then
  printf "%s\n" "You need to set the S3_BUCKET environment variable."
  exit 1
elif [ -z "${CASSANDRA_HOSTS}" ] ; then
  printf "%s\n" "You need to set the CASSANDRA_HOSTS environment variable."
  exit 1
fi

if [ "${S3_IAMROLE}" != "true" ] ; then
  export AWS_ACCESS_KEY_ID=${S3_ACCESS_KEY_ID}
  export AWS_SECRET_ACCESS_KEY=${S3_SECRET_ACCESS_KEY}
  export AWS_DEFAULT_REGION=${S3_REGION}
fi

if [ "${S3_ENCRYPTION}" == "true" ] ; then
  ENCRYPTION_ARGS="--s3-ssenc"
else
  ENCRYPTION_ARGS=""
fi

if [ ! -z "${CASSANDRA_USER}" ] ; then
  AUTH_ARGS="--user=${CASSANDRA_USER} --password=${CASSANDRA_PASSWORD}"
else
  AUTH_ARGS=""
fi

cassandra-snapshotter --s3-bucket-name="${S3_BUCKET}" \
                      --s3-bucket-region="${S3_REGION}" \
                      --s3-base-path="${PROJECTNAME}" \
                      --aws-access-key-id="${AWS_ACCESS_KEY_ID}" \
                      --aws-secret-access-key="${AWS_SECRET_ACCESS_KEY}" \
                      $ENCRYPTION_ARGS \
                      backup \
                      --hosts="${CASSANDRA_HOSTS}" $AUTH_ARGS
