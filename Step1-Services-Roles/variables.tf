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
  default = "us-central1"
}

variable "GCPServiceList" {
  # For a list of services available, visit the API library page or
  # run gcloud services list --available
  type        = list(string)
  description = "The list of apis necessary for the project"
  default     = ["compute.googleapis.com", "storage.googleapis.com"]
}

