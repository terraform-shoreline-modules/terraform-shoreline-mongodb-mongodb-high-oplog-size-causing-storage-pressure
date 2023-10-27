resource "shoreline_notebook" "high_oplog_size_causing_storage_pressure_in_mongodb" {
  name       = "high_oplog_size_causing_storage_pressure_in_mongodb"
  data       = file("${path.module}/data/high_oplog_size_causing_storage_pressure_in_mongodb.json")
  depends_on = [shoreline_action.invoke_data_retention_policy]
}

resource "shoreline_file" "data_retention_policy" {
  name             = "data_retention_policy"
  input_file       = "${path.module}/data/data_retention_policy.sh"
  md5              = filemd5("${path.module}/data/data_retention_policy.sh")
  description      = "Implement a data retention policy to delete old data from the database and oplog. This can help in reducing the amount of data being stored and free up storage space for new data."
  destination_path = "/tmp/data_retention_policy.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_data_retention_policy" {
  name        = "invoke_data_retention_policy"
  description = "Implement a data retention policy to delete old data from the database and oplog. This can help in reducing the amount of data being stored and free up storage space for new data."
  command     = "`chmod +x /tmp/data_retention_policy.sh && /tmp/data_retention_policy.sh`"
  params      = ["COLLECTION_NAME","NUMBER_OF_DAYS","OPLOG_SIZE_LIMIT_IN_MB","DATABASE_NAME"]
  file_deps   = ["data_retention_policy"]
  enabled     = true
  depends_on  = [shoreline_file.data_retention_policy]
}

