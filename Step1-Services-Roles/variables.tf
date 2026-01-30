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
}

# Google Cloud Region
variable "Region" {
  type = string
  description = "Google Cloud Region"
  default = "europe-west4"
}

variable "GCPServiceList" {
  # For a list of services available, visit the API library page or
  # run gcloud services list --available
  type        = list(string)
  description = "The list of apis necessary for the project"
  default     = ["compute.googleapis.com", "storage.googleapis.com"]
}

# Name of the custom role to be used in the NC2 project by Compute Engine instances
variable "NC2NodesCustomRoleName" {
  type        = string
  description = "Name of the custom role to be used by NC2 Compute Engine instances"
  default     = "nc2_nodes_custom_role"
}

# Title of the custom role to be used in the NC2 project by Compute Engine instances
variable "NC2NodesCustomRoleTitle" {
  type        = string
  description = "Title of the custom role to be used by NC2 Compute Engine instances"
  default     = "Custom Role for NC2 Nodes - GCE metal Instances"
}

# Name of the custom role to be used in the NC2 project by the NC2 Portal service account
variable "NC2PortalCustomRoleName" {
  type        = string
  description = "Name of the custom role to be used by NC2 Portal service account"
  default     = "nc2_portal_custom_role"
}

# Title of the custom role to be used in the NC2 project by the NC2 Portal service account
variable "NC2PortalCustomRoleTitle" {
  type        = string
  description = "Title of the custom role to be used by NC2 Portal service account"
  default     = "Custom Role for NC2 Portal"
}

# Name of the service account to be used in the NC2 project for the NC2 Portal
variable "NC2PortalServiceAccountName" {
  type        = string
  description = "Name of the service account to be used by NC2 Portal"
  default     = "nc2-portal-sa"
}

# Name of the service account to be used in the NC2 project for NC2 Nodes (GCE metal instances)
variable "NC2NodesServiceAccountName" {
  type        = string
  description = "Name of the service account to be used by NC2 Nodes (GCE metal instances)"
  default     = "nc2-nodes-sa"
}