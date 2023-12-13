# outputs.tf

output "lke_firewall_id" {
  description = "The ID of the firewall created for the LKE cluster."
  value       = linode_firewall.lke_firewall.id
}

output "lke_firewall_url" {
  description = "The link to the firewall created for the LKE cluster."
  value       = "https://cloud.linode.com/firewalls/${linode_firewall.lke_firewall.id}"
}
