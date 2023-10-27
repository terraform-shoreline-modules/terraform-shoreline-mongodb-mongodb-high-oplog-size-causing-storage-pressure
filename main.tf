terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "high_oplog_size_causing_storage_pressure_in_mongodb" {
  source    = "./modules/high_oplog_size_causing_storage_pressure_in_mongodb"

  providers = {
    shoreline = shoreline
  }
}