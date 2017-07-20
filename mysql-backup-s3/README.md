# mysql-backup-s3

## Environment variables

- `MYSQLDUMP_OPTIONS` mysqldump options (default: --quote-names --quick --add-drop-table --add-locks --allow-keywords --disable-keys --extended-insert --single-transaction --create-options --comments --net_buffer_length=16384)
- `MYSQLDUMP_DATABASE` list of databases you want to backup *required*
- `MYSQL_HOST` the mysql host *required*
- `MYSQL_PORT` the mysql port (default: 3306)
- `MYSQL_USER` the mysql user *required*
- `MYSQL_PASSWORD` the mysql password *required*
- `S3_ACCESS_KEY_ID` your AWS access key *required*
- `S3_SECRET_ACCESS_KEY` your AWS secret key *required*
- `S3_BUCKET` your AWS S3 bucket path *required*
- `S3_PREFIX` path prefix in your bucket *required*
- `S3_REGION` the AWS S3 bucket region (default: eu-central-1)
- `SCHEDULE` backup schedule time, see explainatons below

### Periodic Backups

Use the `SCHEDULE` environment variable with a cron-like syntax to set periodic backups: [Syntax](http://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules).
