variable "VpnGatewayName" {
    description = "Name of the VPN gateway"
    type        = string
}

variable "Network" {
    description = "The VPC network to attach the VPN gateway"
    type        = string
}

variable "Region" {
    description = "Region for the VPN gateway and tunnel"
    type        = string
}

variable "VpnTunnelName" {
    description = "Name of the VPN tunnel"
    type        = string
}

variable "PeerIp" {
    description = "The peer gateway public IP address"
    type        = string
}

variable "SharedSecret" {
    description = "Shared secret for the VPN tunnel"
    type        = string
    sensitive   = true
}

variable "LocalTrafficSelector" {
    description = "CIDR blocks for local traffic selector"
    type        = list(string)
}

variable "RemoteTrafficSelector" {
    description = "CIDR blocks for remote traffic selector"
    type        = list(string)
}

variable "IkeVersion" {
    description = "IKE protocol version"
    type        = number
    default     = 2
}

variable "IkeEncryptionAlgorithm" {
    description = "IKE encryption algorithm"
    type        = string
    default     = "AES_256"
}

variable "IkeIntegrityAlgorithm" {
    description = "IKE integrity algorithm"
    type        = string
    default     = "SHA256"
}

variable "IkeDhGroupNumber" {
    description = "IKE DH group number"
    type        = number
    default     = 14
}

variable "IpsecEncryptionAlgorithm" {
    description = "IPsec encryption algorithm"
    type        = string
    default     = "AES_256"
}

variable "IpsecIntegrityAlgorithm" {
    description = "IPsec integrity algorithm"
    type        = string
    default     = "SHA256"
}

variable "IpsecPfsDhGroupNumber" {
    description = "IPsec PFS DH group number"
    type        = number
    default     = 14
}

resource "google_compute_address" "TF_VpnGatewayStaticIp" {
    name   = "${var.VpnGatewayName}-static-ip"
    region = var.Region
}

resource "google_compute_vpn_gateway" "TF_VPNGateway" {
    name    = var.VpnGatewayName
    network = var.Network
    region  = var.Region

    depends_on = [google_compute_address.TF_VpnGatewayStaticIp]
}

resource "google_compute_vpn_tunnel" "TF_VPN_Tunnel" {
    name                    = var.VpnTunnelName
    region                  = var.Region
    target_vpn_gateway      = google_compute_vpn_gateway.TF_VPNGateway.id
    peer_ip                 = var.PeerIp
    shared_secret           = var.SharedSecret
    ike_version             = var.IkeVersion
    local_traffic_selector  = var.LocalTrafficSelector
    remote_traffic_selector = var.RemoteTrafficSelector

    ike_config {
        encryption_algorithm = var.IkeEncryptionAlgorithm # Options: "AES_128", "AES_192", "AES_256"
        integrity_algorithm  = var.IkeIntegrityAlgorithm  # Options: "SHA1", "SHA256", "SHA384", "SHA512"
        dh_group_number      = var.IkeDhGroupNumber       # Options: 2, 5, 14, 15, 16, 19, 20, 21, 24
    }

    ipsec_config {
        encryption_algorithm = var.IpsecEncryptionAlgorithm # Options: "AES_128", "AES_192", "AES_256"
        integrity_algorithm  = var.IpsecIntegrityAlgorithm  # Options: "SHA1", "SHA256", "SHA384", "SHA512"
        pfs_dh_group_number  = var.IpsecPfsDhGroupNumber  # Options: 2, 5, 14, 15, 16, 19, 20, 21, 24
    }
}

resource "google_compute_forwarding_rule" "VpnGatewayEsp" {
  name        = "${var.VpnGatewayName}-esp"
  region      = var.Region
  ip_protocol = "ESP"
  ip_address  = google_compute_address.TF_VpnGatewayStaticIp.address
  target      = google_compute_vpn_gateway.TF_VPNGateway.id
}

resource "google_compute_forwarding_rule" "VpnGatewayUdp500" {
  name        = "${var.VpnGatewayName}-udp500"
  region      = var.Region
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.TF_VpnGatewayStaticIp.address
  target      = google_compute_vpn_gateway.TF_VPNGateway.id
}

resource "google_compute_forwarding_rule" "VpnGatewayUdp4500" {
  name        = "${var.VpnGatewayName}-udp4500"
  region      = var.Region
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.TF_VpnGatewayStaticIp.address
  target      = google_compute_vpn_gateway.TF_VPNGateway.id
}
