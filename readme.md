# Module - Composer V3
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()
[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![GCP](https://img.shields.io/badge/provider-GCP-green)](https://registry.terraform.io/providers/hashicorp/google/latest)

Module developed to standardize the creation of Composer V3.

## Compatibility Matrix

| Module Version | Terraform Version | Google Version     |
|----------------|-------------------| ------------------ |
| v1.0.0         | v1.9.8            | 6.10.0             |

## Specifying a version

To avoid that your code get the latest module version, you can define the `?ref=***` in the URL to point to a specific version.
Note: The `?ref=***` refers a tag on the git module repo.

## Default use case
```hcl
module "composer-env" {    
  source = "git::https://github.com/danilomnds/terraform-gcp-composer-v3?ref=v1.0.0"
  project = "project_id"
  name = "composer-env"
  region = "<southamerica-east1>"
  config = {
    software_config = {
      image_version = "composer-3-airflow-2"
    }
    environment_size = "ENVIRONMENT_SIZE_SMALL"
    node_config = {
      network    = "projects/<project>/global/networks/<network>"
      subnetwork = "projects/<project>/regions/<region>/subnetworks/<subnetwork>"
    }      
  }
  labels = {
    diretoria   = "ctio"
    area        = "area"
    system      = "system"    
    environment = "fqa"
    projinfra   = "0001"
    dm          = "00000000"
    provider    = "gcp"
    region      = "southamerica-east1"
  }
}
output "id" {
  value = module.composer-env.id
}
```

## Default use case plus RBAC
```hcl
module "composer-env" {    
  source = "git::https://github.com/danilomnds/terraform-gcp-composer-v3?ref=v1.0.0"
  project = "project_id"
  name = "composer-env"
  region = "<southamerica-east1>"
  members = ["group:GRP_GCP-SYSTEM-PRD@timbrasil.com.br"]
  storage_object_admin = true
  config = {
    software_config = {
      image_version = "composer-3-airflow-2"
    }
    environment_size = "ENVIRONMENT_SIZE_SMALL"
    node_config = {
      network    = "projects/<project>/global/networks/<network>"
      subnetwork = "projects/<project>/regions/<region>/subnetworks/<subnetwork>"
    }      
  }
  labels = {
    diretoria   = "ctio"
    area        = "area"
    system      = "system"    
    environment = "fqa"
    projinfra   = "0001"
    dm          = "00000000"
    provider    = "gcp"
    region      = "southamerica-east1"
  }
}
output "id" {
  value = module.composer-env.id
}
```

## Input variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the environment | `string` | n/a | `Yes` |
| config | Configuration parameters for this environment. Structure is documented [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/composer_environment#argument-reference---cloud-composer-3) | `object({})` | n/a | No |
| labels | Labels with user-defined metadata | `map(string)` | n/a | No |
| region | The location or Compute Engine region for the environment | `string` | n/a | No |
| project | The ID of the project in which the resource belongs. If it is not provided, the provider project is used | `string` | n/a | No |
| storage_config | Configuration options for storage used by Composer environment. Structure is documented [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/composer_environment#argument-reference---cloud-composer-3) | `object({})` | n/a | No |
| members | list of azure AD groups that will use the resource | `list(string)` | n/a | No |
| storage_object_admin | Should Cloud Scheduler Admin be granted?  | `bool` | `false` | No |

# Object variables for blocks

Please check the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/composer_environment#argument-reference---cloud-composer-3)

## Output variables

| Name | Description |
|------|-------------|
| id | composer environment id|

## Documentation
Composer: <br>
[https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/composer_environment](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/composer_environment)