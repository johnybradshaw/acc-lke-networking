# variables.tf

variable "linode_config" {
  type = object({
    api_token = string
  })
}

variable "lke_cluster_id" {
  description = "The ID of the LKE cluster"
  type = string
}

variable "lke_nodebalancer" {
  description = "values for the nodebalancer"
  type = object({
    client_conn_throttle = string
  })
  default = {
    client_conn_throttle = "20"
  }
}