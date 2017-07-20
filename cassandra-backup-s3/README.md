# cassandra-backup-s3

## Environment variables

- `PROJECTNAME` used for S3 key *required*
- `CASSANDRA_HOSTS` comma-delimited list of hosts to back up *required*
- `CASSANDRA_USER` username for cassandra
- `CASSANDRA_PASSWORD` password for cassandra
- `S3_ACCESS_KEY_ID` access key for S3 bucket *required*
- `S3_SECRET_ACCESS_KEY` secret access key for S3 bucket *required*
- `S3_BUCKET` name of bucket *required*
- `S3_REGION` default: eu-central-1
- `SCHEDULE` cron syntax for peridoc backups, syntax see below
- `S3_ENCRYPTION` encryption setting for S3 bucket, boolean, default: false
- `NEW_SNAPSHOT` create new snapshot instead of incrementa, boolean, default: false


### Periodic Backups

Use the `SCHEDULE` environment variable with a cron-like syntax to set periodic backups: [Syntax](http://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules).
