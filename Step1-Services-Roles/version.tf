
# cf. https://registry.terraform.io/providers/hashicorp/google/latest/docs
terraform {
    required_providers {
        google = {
      source = "hashicorp/google"
      version = "6.39.0"
    }
    }
    required_version = ">= 1.3.0"
}

provider "google" {
    project = var.ProjectID
    region  = var.Region
}

