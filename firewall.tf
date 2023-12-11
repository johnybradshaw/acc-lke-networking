# firewall.tf

# Create a firewall to prevent unauthorized access to the cluster
resource "linode_firewall" "lke_firewall" {
    depends_on = [ data.linode_lke_cluster.lke_cluster ] # Wait for the LKE cluster to be created
    
    label = "${data.linode_lke_cluster.lke_cluster.label}-firewall"
    tags  = data.linode_lke_cluster.lke_cluster.tags
    # TCP port 10250 from 192.168.128.0/17 Accept, Kubelet health checks
    inbound {
        label = "inbound-kubelet-health-checks"
        action = "ACCEPT"
        protocol = "TCP"
        ports = "10250"
        ipv4 = ["192.168.128.0/17"]
    }
    # UDP port 51820 from 192.168.128.0/17 Accept, Wireguard tunneling for kubectl proxy
    inbound {
        label = "inbound-wireguard-kubectl-proxy"
        action = "ACCEPT"
        protocol = "UDP"
        ports = "51820"
        ipv4 = ["192.168.128.0/17"]
    }
    # TCP port 179 from 192.168.128.0/17 Accept, Calico BGP traffic
    inbound {
        label = "inbound-calico-bgp"
        action = "ACCEPT"
        protocol = "TCP"
        ports = "179"
        ipv4 = ["192.168.128.0/17"]
    }
    # TCP/UDP port 30000 - 32767 192.168.128.0/17 Accept, NodePorts for workload Services
    inbound {
        label = "inbound-nodeports-for-workloads"
        action = "ACCEPT"
        protocol = "TCP"
        ports = "30000-32767"
        ipv4 = ["192.168.128.0/17"]
    }
   # TCP/UDP/ICMP All Ports All IPv4/All IPv6 Drop, Block all other traffic
    inbound {
        label = "inbound-tcp-all-ipv4-ipv6"
        action = "DROP"
        protocol = "TCP"
        ipv4 = ["0.0.0.0/0"]
        ipv6 = ["::/0"]
    }
    inbound {
        label = "inbound-udp-all-ipv4-ipv6"
        action = "DROP"
        protocol = "UDP"
        ipv4 = ["0.0.0.0/0"]
        ipv6 = ["::/0"]
    }
    inbound {
        label = "inbound-icmp-all-ipv4-ipv6"
        action = "DROP"
        protocol = "ICMP"
        ipv4 = ["0.0.0.0/0"]
        ipv6 = ["::/0"]
    }

    inbound_policy = "ACCEPT"
    outbound_policy = "ACCEPT"

    // Capture the Linode IDs for the LKE cluster nodes
    // and add them to the firewall
    linodes = flatten([for pool in data.linode_lke_cluster.lke_cluster.pools : [for node in pool.nodes : node.instance_id]])
}