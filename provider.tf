# terraform.tf

terraform {
    required_version = ">= 1.5.7"

    required_providers {
        linode = {
            source = "linode/linode"
            version = ">= 2.9.3"
        }
    }
}

provider "linode" {
  token = var.linode_config.api_token
}