variable "name" {
  type = string
}

variable "config" {
  type = object({
    node_config = optional(object({
      network                           = optional(string)
      subnetwork                        = optional(string)
      composer_network_attachment       = optional(string)
      service_account                   = optional(string)
      tags                              = optional(list(string))
      composer_internal_ipv4_cidr_block = optional(string)
    }))
    software_config = optional(object({
      airflow_config_overrides = optional(map(string))
      pypi_packages            = optional(map(string))
      env_variables            = optional(map(string))
      image_version            = string
      cloud_data_lineage_integration = optional(object({
        enabled = string
      }))
      web_server_plugins_mode = optional(string)
    }))
    enable_private_environment = optional(bool)
    enable_private_builds_only = optional(bool)
    encryption_config = optional(object({
      kms_key_name = string
    }))
    maintenance_window = optional(object({
      start_time = string
      end_time   = string
      recurrence = string
    }))
    workloads_config = optional(object({
      scheduler = optional(object({
        cpu        = optional(number)
        memory_gb  = optional(number)
        storage_gb = optional(number)
        count      = optional(number)
      }))
      triggerer = optional(object({
        cpu       = optional(number)
        memory_gb = optional(number)
        count     = optional(number)
      }))
      web_server = optional(object({
        cpu        = optional(number)
        memory_gb  = optional(number)
        storage_gb = optional(number)
      }))
      worker = optional(object({
        cpu        = optional(number)
        memory_gb  = optional(number)
        storage_gb = optional(number)
        min_count  = optional(number)
        max_count  = optional(number)
      }))
      dag_processor = optional(object({
        cpu        = optional(number)
        memory_gb  = optional(number)
        storage_gb = optional(number)
        count      = optional(number)
      }))
    }))
    environment_size = optional(string)
    data_retention_config = optional(object({
      task_logs_retention_config = optional(object({
        storage_mode = optional(string)
      }))
    }))
  })
  default = null
}

variable "labels" {
  type    = map(string)
  default = null
}

variable "region" {
  type = string
}

variable "project" {
  type    = string
  default = null
}

variable "storage_config" {
  type = object({
    bucket = string
  })
  default = null
}

variable "members" {
  type    = list(string)
  default = []
}