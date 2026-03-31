# This resource creates a custom VPC network WITHOUT auto-created subnetworks.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "terra_custom_vpc" {
  name                    = var.VPCName
  auto_create_subnetworks = false
  mtu                     = 2000 # must be >= 2000 for NC2 on GCP. 2000 is the default value applied if NC2 portal is creating the Google VPC during NC2 cluster deployment.
}

# # Cloud DNS policy for the VPC can be added here if needed
## PLEASE AVOID because it can cause issues with NC2 cluster deployment and operation if not properly configured, especially if you are not familiar with Google Cloud DNS policies and their impact on VPC-level DNS resolution.
# # cf. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_policy 
# # example of a DNS policy with alternative name servers and logging enabled :
# # https://developers.cloudflare.com/1.1.1.1/setup/google-cloud/
# resource "google_dns_policy" "terra-DNS-policy" {
#   name                      = "nc2-dns-policy"
#   enable_inbound_forwarding = true
#   enable_logging = true

#   alternative_name_server_config {
#     target_name_servers {
#       ipv4_address    = "8.8.8.8" # Google Public DNS server for VPC-level DNS resolution (in addition to the default metadata server) 
#     }
#     target_name_servers {
#       ipv4_address = "1.1.1.1" # cloudflare public DNS server as an alternative to Google Public DNS
#     }

#   }

#   networks {
#     network_url = google_compute_network.terra_custom_vpc.id
#   }
# }


# Peering with other Google VPCs can be added here if needed
# cf. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network_peering
# VERY IMPORTANT : Ensure that you enable export_custom_routes (created for Nutanix FLOW VPC NoNAT ERP)
# export_custom_routes = true







# This resource creates a subnetwork within the custom VPC using the specified CIDR range and region.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "terra_cluster_management_subnet" {
  name          = var.ManagementSubnetName
  ip_cidr_range = var.ClusterManagementSubnetCidr
  region        = var.Region
  network       = google_compute_network.terra_custom_vpc.id
  secondary_ip_range {
    range_name    = "secondary-range-for-nat"
    ip_cidr_range = var.NATSubnetCidr
  }
  # private_ip_google_access = true # This allows VMs without external IPs in this subnet to access Google APIs and services through the private Google access feature, which is important for NC2 cluster management and operation
}

# This resource creates a subnetwork within the custom VPC using the specified CIDR range and region.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "terra_NoNAT_subnet" {
  name          = "nonat-subnet"
  ip_cidr_range = var.NoNATSubnetCidr
  region        = var.Region
  network       = google_compute_network.terra_custom_vpc.id
}



### Cloud NAT for the VPC
# cf. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
resource "google_compute_router" "terra_router" {
  name    = "my-router"
  region  = google_compute_subnetwork.terra_cluster_management_subnet.region
  network = google_compute_network.terra_custom_vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "terra_nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.terra_router.name
  region                             = google_compute_router.terra_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

#### End of Cloud NAT configuration


## VPN Gateway (Classic VPN) and its associated resources
## cf. https://cloud.google.com/network-connectivity/docs/vpn/how-to/creating-static-vpns#gcloud

resource "google_compute_address" "TF_VpnGatewayStaticIp" {
    name   = "${var.VpnGatewayName}-static-ip"
    region = var.Region
}

resource "google_compute_vpn_gateway" "TF_VPNGateway" {
    name    = var.VpnGatewayName
    network = google_compute_network.terra_custom_vpc.id
    region  = var.Region

    depends_on = [google_compute_address.TF_VpnGatewayStaticIp]
}


# Three forwarding rules have been added to your configuration:
# ESP (IPsec), UDP 500 (IKE), and UDP 4500 (IPsec NAT-T) traffic
# will be sent to the VPN gateway. 
# This completes the required setup for Classic VPN traffic forwarding 
# in Google Cloud


resource "google_compute_forwarding_rule" "TF_VpnGatewayEsp" {
  name        = "${var.VpnGatewayName}-esp"
  region      = var.Region
  ip_protocol = "ESP"
  ip_address  = google_compute_address.TF_VpnGatewayStaticIp.address
  target      = google_compute_vpn_gateway.TF_VPNGateway.id
}

resource "google_compute_forwarding_rule" "TF_VpnGatewayUdp500" {
  name        = "${var.VpnGatewayName}-udp500"
  region      = var.Region
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.TF_VpnGatewayStaticIp.address
  target      = google_compute_vpn_gateway.TF_VPNGateway.id
}

resource "google_compute_forwarding_rule" "TF_VpnGatewayUdp4500" {
  name        = "${var.VpnGatewayName}-udp4500"
  region      = var.Region
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.TF_VpnGatewayStaticIp.address
  target      = google_compute_vpn_gateway.TF_VPNGateway.id
}


# This resource creates a VPN tunnel with the specified parameters.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_vpn_tunnel

resource "google_compute_vpn_tunnel" "TF_VPN_Tunnel" {
    name                    = var.VpnTunnelName
    region                  = var.Region
    target_vpn_gateway      = google_compute_vpn_gateway.TF_VPNGateway.id
    peer_ip                 = var.PeerIp
    shared_secret           = var.SharedSecret
    ike_version             = var.IkeVersion

   
    # cf. https://cloud.google.com/network-connectivity/docs/vpn/concepts/choosing-networks-routing#static-routing
    # cf. https://cloud.google.com/network-connectivity/docs/vpn/how-to/creating-static-vpns. 
    # With route-based VPN, you specify only the remote traffic selector.
    # If you need to specify a local traffic selector, create a Cloud VPN tunnel that uses policy-based routing instead.
    # The local_traffic_selector field cannot be empty for network in custom subnet mode
    local_traffic_selector  = var.LocalTrafficSelector
    # remote_traffic_selector = var.RemoteTrafficSelector

    # cipher_suite {
    #     phase1 {
    #     encryption = ["AES-CBC-256"]
    #     integrity  = ["HMAC-SHA2-256-128"]
    #     prf        = ["PRF-HMAC-SHA2-256"]
    #     dh         = ["Group-14"]
    #     }
    #     phase2 {
    #     encryption = ["AES-CBC-128"]
    #     integrity  = ["HMAC-SHA2-256-128"]
    #     pfs        = ["Group-14"]
    #     }
    # }

    # ike_config {
    #     encryption_algorithm = var.IkeEncryptionAlgorithm # Options: "AES_128", "AES_192", "AES_256"
    #     integrity_algorithm  = var.IkeIntegrityAlgorithm  # Options: "SHA1", "SHA256", "SHA384", "SHA512"
    #     dh_group_number      = var.IkeDhGroupNumber       # Options: 2, 5, 14, 15, 16, 19, 20, 21, 24
    # }

    # ipsec_config {
    #     encryption_algorithm = var.IpsecEncryptionAlgorithm # Options: "AES_128", "AES_192", "AES_256"
    #     integrity_algorithm  = var.IpsecIntegrityAlgorithm  # Options: "SHA1", "SHA256", "SHA384", "SHA512"
    #     pfs_dh_group_number  = var.IpsecPfsDhGroupNumber  # Options: 2, 5, 14, 15, 16, 19, 20, 21, 24
    # }

    depends_on = [
        google_compute_forwarding_rule.TF_VpnGatewayEsp,
        google_compute_forwarding_rule.TF_VpnGatewayUdp500,
        google_compute_forwarding_rule.TF_VpnGatewayUdp4500,
    ]
}





# Complete the configuration
# Before you can use a new Cloud VPN gateway and its associated VPN tunnel, complete the following steps:

# Set up the peer VPN gateway and configure the corresponding tunnel there. For instructions, see the following:
# For specific configuration guidance for certain peer VPN devices, see Use third-party VPNs.
# For general configuration parameters, see Configure the peer VPN gateway.
# Configure firewall rules in Google Cloud and your peer network as required.
# Check the status of your VPN tunnel and forwarding rules.
# View your VPN routes by going to the project routing table and filtering for Next hop type:VPN tunnel:
# https://cloud.google.com/network-connectivity/docs/vpn/concepts/choosing-networks-routing
# https://cloud.google.com/network-connectivity/docs/vpn/how-to/creating-static-vpns 

resource "google_compute_route" "TF_Route_to_on_premises" {
  name       = "route-to-on-premises"
  network    = google_compute_network.terra_custom_vpc.id
  dest_range = "10.0.0.0/8"  # Replace with your on-premises network CIDR
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.TF_VPN_Tunnel.id  
}


# ## A firewall rule to allow traffic from the VPN tunnel to the custom VPC network.
## cf. https://cloud.google.com/vpc/docs/firewalls
## cf. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "TF_allow_vpn_traffic" {
  name    = "allow-vpn-traffic"
  network = google_compute_network.terra_custom_vpc.id        
    allow {
        protocol = "udp"
        ports    = ["500", "4500"]  # IKE and IPsec NAT-T ports
    }
    source_ranges = ["0.0.0.0/0"]  # Allow traffic from any source
}


# ## A firewall rule to allow traffic from the VPN tunnel to the custom VPC network.
## cf. https://cloud.google.com/vpc/docs/firewalls
## cf. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "TF_allow_traffic_from_vpn_tunnel" {
  name    = "allow-traffic-from-vpn-tunnel"
  network = google_compute_network.terra_custom_vpc.id        
    allow {
        protocol = "tcp"
        ports    = ["22", "3389", "80", "443", "9440"]  # Adjust ports as needed
    }
    allow {
        protocol = "icmp"  # ICMP protocol
    }
    source_ranges = var.RemoteTrafficSelector  # Allow traffic from any source
}

