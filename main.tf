resource "google_composer_environment" "composerv3" {
  name    = var.name
  labels  = var.labels
  region  = var.region
  project = var.project
  dynamic "config" {
    for_each = var.config != null ? [var.config] : []
    content {
      dynamic "node_config" {
        for_each = config.value.node_config != null ? [config.value.node_config] : []
        content {
          network    = lookup(node_config.value, "network", null)
          subnetwork = lookup(node_config.value, "subnetwork", null)
          #composer_network_attachment = lookup(node_config.template, "composer_network_attachment", null)
          service_account = lookup(node_config.value, "service_account", null)
          tags            = lookup(node_config.value, "tags", null)
          #composer_internal_ipv4_cidr_block = lookup(node_config.template, "composer_internal_ipv4_cidr_block", null)
        }
      }
      dynamic "software_config" {
        for_each = config.value.software_config != null ? [config.value.software_config] : []
        content {
          airflow_config_overrides = lookup(software_config.value, "airflow_config_overrides", null)
          pypi_packages            = lookup(software_config.value, "pypi_packages", null)
          env_variables            = lookup(software_config.value, "env_variables", null)
          image_version            = lookup(software_config.value, "image_version", null)
          dynamic "cloud_data_lineage_integration" {
            for_each = software_config.value.cloud_data_lineage_integration != null ? [software_config.value.cloud_data_lineage_integration] : []
            content {
              enabled = cloud_data_lineage_integration.value.enabled
            }
          }
          #web_server_plugins_mode = lookup(software_config.template, "web_server_plugins_mode", null)            
        }
      }
      #enable_private_environment = lookup(config.value, "enable_private_environment", null)
      #enable_private_builds_only = lookup(config.value, "enable_private_builds_only", null)
      dynamic "encryption_config" {
        for_each = config.value.encryption_config != null ? [config.value.encryption_config] : []
        content {
          kms_key_name = encryption_config.value.kms_key_name
        }
      }
      dynamic "maintenance_window" {
        for_each = config.value.maintenance_window != null ? [config.value.maintenance_window] : []
        content {
          start_time = maintenance_window.value.start_time
          end_time   = maintenance_window.value.end_time
          recurrence = maintenance_window.value.recurrence
        }
      }
      dynamic "workloads_config" {
        for_each = config.value.workloads_config != null ? [config.value.workloads_config] : []
        content {
          dynamic "scheduler" {
            for_each = workloads_config.value.scheduler != null ? [workloads_config.value.scheduler] : []
            content {
              cpu        = lookup(scheduler.value, "cpu", null)
              memory_gb  = lookup(scheduler.value, "memory_gb", null)
              storage_gb = lookup(scheduler.value, "storage_gb", null)
              count      = lookup(scheduler.value, "count", null)
            }
          }
          dynamic "triggerer" {
            for_each = workloads_config.value.triggerer != null ? [workloads_config.value.triggerer] : []
            content {
              cpu       = lookup(triggerer.value, "cpu", null)
              memory_gb = lookup(triggerer.value, "memory_gb", null)
              count     = lookup(triggerer.value, "count", null)
            }
          }
          dynamic "web_server" {
            for_each = workloads_config.value.web_server != null ? [workloads_config.value.web_server] : []
            content {
              cpu        = lookup(web_server.value, "cpu", null)
              memory_gb  = lookup(web_server.value, "memory_gb", null)
              storage_gb = lookup(web_server.value, "storage_gb", null)
            }
          }
          dynamic "worker" {
            for_each = workloads_config.value.worker != null ? [workloads_config.value.worker] : []
            content {
              cpu        = lookup(worker.value, "cpu", null)
              memory_gb  = lookup(worker.value, "memory_gb", null)
              storage_gb = lookup(worker.value, "storage_gb", null)
              min_count  = lookup(worker.value, "min_count", null)
              max_count  = lookup(worker.value, "max_count", null)
            }
          }
          # beta
          /*
          dynamic "dag_processor" {
            for_each = workloads_config.value.dag_processor != null ? [workloads_config.value.dag_processor] : []
            content {
              cpu        = lookup(dag_processor.value, "cpu", null)
              memory_gb  = lookup(dag_processor.value, "memory_gb", null)
              storage_gb = lookup(dag_processor.value, "storage_gb", null)
              count      = lookup(dag_processor.value, "count", null)
            }
          }
          */
        }
      }
      environment_size = lookup(config.value, "environment_size", null)
      dynamic "data_retention_config" {
        for_each = config.value.data_retention_config != null ? [config.value.data_retention_config] : []
        content {
          dynamic "task_logs_retention_config" {
            for_each = data_retention_config.value.task_logs_retention_config != null ? [data_retention_config.value.task_logs_retention_config] : []
            content {
              storage_mode = lookup(task_logs_retention_config.value, "storage_mode", null)
            }
          }
        }
      }
    }
  }
  dynamic "storage_config" {
    for_each = var.storage_config != null ? [var.storage_config] : []
    content {
      bucket = storage_config.value.bucket
    }
  }
  lifecycle {
    ignore_changes = []
  }
}

resource "google_project_iam_binding" "CustomComposerAdministrator" {
  depends_on = [google_composer_environment.composerv3]
  count      = length(var.members) == 0 ? 0 : 1
  project    = var.project
  role       = "organizations/225850268505/roles/CustomComposerAdministrator"
  members    = var.members
}

resource "google_project_iam_binding" "StorageObjectAdmin" {
  depends_on = [google_composer_environment.composerv3]
  count      = var.storage_object_admin == true ? 1 : 0
  project    = var.project
  role       = "roles/storage.objectAdmin"
  members    = var.members
}