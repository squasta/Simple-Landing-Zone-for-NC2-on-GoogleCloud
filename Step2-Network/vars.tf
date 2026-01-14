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
  default = "your-project-id"
}

# Google Cloud Region
variable "Region" {
  type = string
  description = "Google Cloud Region"
  default = "europe-west4"
}

# VPC Name
variable "VPCName" {
  description = "Name of the custom VPC"
  type        = string
  default     = "terra-custom-vpc"
}

variable "ClusterManagementSubnetCidr" {
  description = "CIDR range for the Cluster Management VPC subnet"
  type        = string
  default     = "172.16.0.0/16"
}

variable "NATSubnetCidr" {
  description = "CIDR range for the NoNAT VPC subnet"
  type        = string
  default     = "172.17.0.0/16"
}

variable "NoNATSubnetCidr" {
  description = "CIDR range for the NoNAT VPC subnet"
  type        = string
  default     = "172.18.0.0/16"
}


#### For Jumbox VM instance

# Enable VM Jumbox (0=disable, 1=enable)
variable "EnableJumbox" {
  description = "Enable Jumbox VM instance"
  type        = number
  default     = 0
}



##### FOR VPN GATEWAY AND TUNNEL

variable "VpnGatewayName" {
    description = "Name of the VPN gateway"
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

## Jumbox VM instance 


# Zone for the VM instance
# gcloud compute zones list
# gcloud compute zones list --filter="region:(europe-west4)"
# https://cloud.google.com/compute/docs/regions-zones
variable "VmZone" {
  description = "Zone for the VM instance"
  type        = string
  default     = "europe-west4-b"
}

# Service account email for the VM instance
variable "VmServiceAccountEmail" {
  description = "Service account email for the VM instance"
  type        = string
}