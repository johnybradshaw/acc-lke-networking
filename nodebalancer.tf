# nodebalancer.tf

data "linode_lke_cluster" "lke_cluster" {
  id = var.lke_cluster_id
}

# Create a NodeBalancer to route traffic to the cluster
resource "linode_nodebalancer" "lke_nodebalancer" {
  label  = data.linode_lke_cluster.lke_cluster.label
  region = data.linode_lke_cluster.lke_cluster.region
  tags   = data.linode_lke_cluster.lke_cluster.tags
  client_conn_throttle = var.lke_nodebalancer.client_conn_throttle
}

