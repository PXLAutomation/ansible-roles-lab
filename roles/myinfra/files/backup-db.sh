#!/bin/bash
# Simple database backup script
BACKUP_DIR="/var/backups/mysql"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR
mysqldump --all-databases > $BACKUP_DIR/backup_$TIMESTAMP.sql
find $BACKUP_DIR -type f -name "backup_*.sql" -mtime +7 -delete
