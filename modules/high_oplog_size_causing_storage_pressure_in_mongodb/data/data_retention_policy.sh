

#!/bin/bash



# Set retention period in days

retention_period=${NUMBER_OF_DAYS}



# Set database name

database_name=${DATABASE_NAME}



# Set collection name

collection_name=${COLLECTION_NAME}



# Set oplog size limit in MB

oplog_size_limit=${OPLOG_SIZE_LIMIT_IN_MB}



# Create a timestamp for the retention period

timestamp=$(date -d "$retention_period days ago" +%s)



# Delete old data from the collection

mongo $database_name --eval "db.$collection_name.deleteMany({timestamp: {\$lt: $timestamp}})"



# Reduce the oplog size

mongo $database_name --eval "db.runCommand({replSetResizeOplog: 1, size: $oplog_size_limit})"



echo "Data retention policy has been implemented successfully."