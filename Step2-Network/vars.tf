
#  __      __        _       _     _           
#  \ \    / /       (_)     | |   | |          
#   \ \  / /_ _ _ __ _  __ _| |__ | | ___  ___ 
#    \ \/ / _` | '__| |/ _` | '_ \| |/ _ \/ __|
#     \  / (_| | |  | | (_| | |_) | |  __/\__ \
#      \/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
#
#### VARIABLES DEFINITION with default values
#### please enter or check your values in configuration.tfvars  


# variale Jumbox Virtual Machine Name
variable "jumbox_vm_name" {
  description = "Name of the Jumbox Virtual Machine"
  type        = string
  default     = "jumbox-vm"
}

# Google Project ID
variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
  default     = "emea-portfolio-nc2"
}

# Google Cloud Region
variable "region" {
  description = "Google Cloud Region"
  type        = string
  default     = "us-central1"
}
# Google Cloud Zone
variable "zone" {
  description = "Google Cloud Zone"
  type        = string
  default     = "us-central1-a"
}

# Google Cloud Network VPC name
variable "network_name" {
  description = "Google Cloud Network VPC name"
  type        = string
  default     = "bngcpvpc"
}

# Google Cloud Subnetwork name
variable "subnetwork_name" {
  description = "Google Cloud Subnetwork name"
  type        = string
  default     = "bngcpvpc-subnet01"
}
# Google Cloud Subnetwork IP CIDR
variable "subnetwork_ip_cidr" {
  description = "Google Cloud Subnetwork IP CIDR"
  type        = string
  default     = ""
}

# Google Cloud Subnetwork IP CIDR
  variable "subnetwork_ip_cidr" {
  description = "Google Cloud Subnetwork IP CIDR"
  type        = string
  default     = ""
  }

 # Use a spot (preemptible) instance for jumbox VM
  variable "enable_spot_instance" {
  description = "Enable Spot Instance"
  type        = number
  default     = 0      # (=false)
}
