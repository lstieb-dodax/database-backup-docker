# mongodb-backup-s3

## Environment variables

- `MONGO_DATABASE`  database you want to backup *required*
- `MONGO_CONFIGDB` the configdb string for the mongos router *required*
- `S3_ACCESS_KEY_ID` your AWS access key *required*
- `S3_SECRET_ACCESS_KEY` your AWS secret key *required*
- `S3_BUCKET` your AWS S3 bucket path *required*
- `S3_PREFIX` path prefix in your bucket *required*
- `S3_REGION` the AWS S3 bucket region (default: eu-central-1)
- `SCHEDULE` backup schedule time, see explainatons below

### Periodic Backups

Use the `SCHEDULE` environment variable with a cron-like syntax to set periodic backups: [Syntax](http://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules).
