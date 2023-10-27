
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High Oplog Size Causing Storage Pressure in MongoDB
---

This incident type refers to a situation where the oplog size in MongoDB has increased significantly and is causing storage pressure. Oplog is the operation log that records all the write operations on a MongoDB instance. When the oplog size becomes too large, it can lead to storage pressure on the system, causing slow performance and even system crashes. It is important to monitor the oplog size and take appropriate actions to avoid this incident type.

### Parameters
```shell
export MONGODB_CONNECTION_STRING="PLACEHOLDER"

export NUMBER_OF_DAYS="PLACEHOLDER"

export COLLECTION_NAME="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export OPLOG_SIZE_LIMIT_IN_MB="PLACEHOLDER"
```

## Debug

### Check disk usage
```shell
df -h
```

### Check MongoDB version
```shell
mongod --version
```

### Check the size of the collections in the database
```shell
mongo ${MONGODB_CONNECTION_STRING} --eval "db.getCollectionInfos({},{size:true})"
```

### Check the size of the oplog
```shell
mongo ${MONGODB_CONNECTION_STRING} --eval "printjson(db.getReplicationInfo())"
```

### Check the total size of the database
```shell
mongo ${MONGODB_CONNECTION_STRING} --eval "printjson(db.stats())"
```

### Check the indexes on the collections
```shell
mongo ${MONGODB_CONNECTION_STRING} --eval "db.collection.getIndexes()"
```

### Check the active connections in the database
```shell
mongo ${MONGODB_CONNECTION_STRING} --eval "db.currentOp(true)"
```

### Check the logs for any errors or warnings
```shell
tail /var/log/mongodb/mongod.log
```

## Repair

### Implement a data retention policy to delete old data from the database and oplog. This can help in reducing the amount of data being stored and free up storage space for new data.
```shell


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


```