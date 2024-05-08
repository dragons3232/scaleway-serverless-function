terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
    archive = {
      source = "hashicorp/archive"
    }
  }
  required_version = ">= 0.13"
}

variable "project_id" {
  type = string
  sensitive = true
}

variable "scw_access_key_id" {
  type      = string
  sensitive = true
}

variable "scw_secret_access_key" {
  type      = string
  sensitive = true
}

variable "any_var" {
  type      = string
  sensitive = true
}

variable "DATABASE_URL" {
  type      = string
  sensitive = true
}

provider "scaleway" {
  zone = "fr-par-1"
}

// MNQ Nats

resource "scaleway_mnq_nats_account" "hello" {
  name = "nats-acc-hello"
  project_id = var.project_id
}

resource "scaleway_mnq_nats_credentials" "hello" {
  name       = "nats-hello-creds"
  account_id = scaleway_mnq_nats_account.hello.id
}

resource "local_file" "nats_credential" {
  content         = scaleway_mnq_nats_credentials.hello.file
  filename        = "nats.creds"
  file_permission = 644
}

output "nats_url" {
  value       = scaleway_mnq_nats_account.hello.endpoint
  description = "NATS url to use with the producer script"
}

// Function
data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "./function/dist"
  output_path = "./function.zip"
}

resource "scaleway_function_namespace" "hello" {
  name        = "hello-namespace"
  description = "hello namespace"
  project_id = var.project_id
}

resource "scaleway_function" "hello" {
  namespace_id = scaleway_function_namespace.hello.id
  runtime      = "node16"
  handler      = "handler/hello.handle"
  name         = "hello"
  privacy      = "public"
  zip_file     = "function.zip"
  zip_hash     = data.archive_file.function_zip.output_sha256
  deploy       = true
  memory_limit = "2048"
  environment_variables = {
    any_var = var.any_var
    DATABASE_URL = var.DATABASE_URL
  }
  secret_environment_variables = {
    ACCESS_KEY_ID     = var.scw_access_key_id
    SECRET_ACCESS_KEY = var.scw_secret_access_key
  }

  depends_on = [data.archive_file.function_zip]
}

resource "scaleway_function_trigger" "hello" {
  function_id = scaleway_function.hello.id
  name        = "hello-nats-trigger"
  nats {
    account_id = scaleway_mnq_nats_account.hello.id
    subject    = "hello-nats"
    project_id = var.project_id
  }
}