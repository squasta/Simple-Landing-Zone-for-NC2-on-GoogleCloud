#  __      __        _       _     _           
#  \ \    / /       (_)     | |   | |          
#   \ \  / /_ _ _ __ _  __ _| |__ | | ___  ___ 
#    \ \/ / _` | '__| |/ _` | '_ \| |/ _ \/ __|
#     \  / (_| | |  | | (_| | |_) | |  __/\__ \
#      \/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
#
#### VARIABLES DEFINITION with default values
#### please enter or check your values in configuration.tfvars  

# Google ProjectID 
variable "ProjectID" {
  type = string
  description = "Google Cloud Project ID" 
  default = "emea-portfolio-nc2"
}

# Google Cloud Region
variable "Region" {
  type = string
  description = "Google Cloud Region"
  default = "europe-west4"
}

variable "CustomVpcSubnetCidr" {
  description = "CIDR range for the custom VPC subnet"
  type        = string
  default     = "172.16.0.0/16"
}

##### FOR VPN GATEWAY AND TUNNEL

variable "VpnGatewayName" {
    description = "Name of the VPN gateway"
    type        = string
    default     = "stanislas-vpn-gateway"
}


variable "VpnTunnelName" {
    description = "Name of the VPN tunnel"
    type        = string
    default     = "stanislas-vpn-tunnel"
}

variable "PeerIp" {
    description = "The peer gateway public IP address"
    type        = string
    default     = "83.114.102.133"
}

variable "SharedSecret" {
    description = "Shared secret for the VPN tunnel"
    type        = string
    default     = "KWfUu1mR8CawJGF1a0I5PBrIcE/hMrdl"
    sensitive   = true
}

# a comma-delimited list of the Google Cloud IP ranges.
# For example, you can supply the CIDR block for each subnet in a VPC network.
# This is the left side from the perspective of Cloud VPN.
variable "LocalTrafficSelector" {
    description = "CIDR blocks for local traffic selector"
    type        = list(string)
    default     = ["172.16.0.0/16"]
}

# a comma-delimited list of the peer network IP ranges. 
# This is the right side from the perspective of Cloud VPN.
variable "RemoteTrafficSelector" {
    description = "CIDR blocks for remote traffic selector"
    type        = list(string)
    default     = ["10.0.0.0/8"]
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