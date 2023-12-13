# main.tf

data "linode_lke_cluster" "lke_cluster" {
  id = var.lke_cluster_id
}