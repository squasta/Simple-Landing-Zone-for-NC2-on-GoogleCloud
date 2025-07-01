
#
# Enable the Compute Engine API (and more if necessary) for the Google Project
## cf. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
resource "google_project_service" "TF_Enabled_APIs" {
  project                    = var.ProjectID
  # toset() is used to ensure that the services are unique
  # and to avoid duplicates in the list.
  # This is important because google_project_service requires a set of services.
  # If the same service is listed multiple times, it will cause an error.
  # cf. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
  for_each                   = toset(var.GCPServiceList)
  service                    = each.key
  disable_dependent_services = true
  disable_on_destroy         = true
   timeouts {
    create = "30m"
    update = "40m"
  }
}




# Customer role to be used in the NC2 project for Compute Engine instances
# cf. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam_custom_role
resource "google_project_iam_custom_role" "TF_Custom_Role_NC2_Nodes" {
    # Ensure the role_id is unique and follows GCP naming conventions
    # Role ID must be lowercase, can contain letters, numbers, and underscores, and must be between 1-64 characters long.
    # For example, "nc2_nodes_custom_role" or "nc2_nodes_role_2023"
    # Adjust the role_id as needed to fit your naming conventions and requirements.
    # Example: "nc2_nodes_custom_role"§
    role_id     = "nc2_nodes_CustomRole"
    title       = "Custom Role for NC2 Nodes - GCE metal Instances"
    description = "A custom role for NC2 Nodes"
    project     = var.ProjectID
    stage       = "GA"

    permissions = [
        "compute.instances.get",
        "compute.instances.updateNetworkInterface",
        "compute.regionBackendServices.get",
        "compute.instances.use",
        "compute.networkEndpointGroups.use",
        "compute.regionBackendServices.update",
        "compute.zones.get",
        "compute.instances.list",
        "compute.networkEndpointGroups.list",
        "compute.forwardingRules.get",
        "compute.subnetworks.list",
        "compute.routes.list",
        "compute.routes.create",
        "compute.networks.updatePolicy",
        "compute.routes.delete"
        # Add any additional permissions required for NC2 nodes
    ]
}


# Ensure the service account email is constructed correctly for the default Compute Engine default service account
locals {
    compute_service_account_email = "${var.ProjectID}-compute@developer.gserviceaccount.com"
}

# Assign the custom role TF_Custom_Role_NC2_Nodes to the default Compute service account of the project
# cf. 
resource "google_project_iam_member" "TF_Compute_SA_NC2_Custom_Role_Binding" {
    project = var.ProjectID
    role    = google_project_iam_custom_role.TF_Custom_Role_NC2_Nodes.name
    member  = "serviceAccount:${locals.compute_service_account_email}"
    depends_on = [
        google_project_iam_custom_role.TF_Custom_Role_NC2_Nodes
    ]
}



resource "google_service_account" "TF_NC2_Portal_SA" {
    account_id   = "nc2-portal-sa"
    display_name = "NC2 Portal Service Account"
    project      = var.ProjectID
}

# Custom role for NC2 Portal with specific permissions
# cf. https://cloud.google.com/iam/docs/creating-custom-roles
# cf. # cf. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam_custom_role
# This role is designed to provide necessary permissions for the NC2 Portal service account
resource "google_project_iam_custom_role" "TF_Custom_Role_NC2_Portal" {
    role_id     = "nc2_portal_custom_role"
    title       = "Custom Role for NC2 Portal"
    description = "A custom role for NC2 Portal specific permissions"
    project     = var.ProjectID
    stage       = "GA"

    permissions = [
        "compute.addresses.create",
        "compute.addresses.createInternal",
        "compute.addresses.delete",
        "compute.addresses.deleteInternal",
        "compute.addresses.get",
        "compute.addresses.list",
        "compute.addresses.setLabels",
        "compute.addresses.use",
        "compute.addresses.useInternal",
        "compute.disks.create",
        "compute.disks.setLabels",
        "compute.disks.use",
        "compute.disks.useReadOnly",
        "compute.firewalls.create",
        "compute.firewalls.delete",
        "compute.firewalls.get",
        "compute.firewalls.list",
        "compute.firewalls.update",
        "compute.forwardingRules.create",
        "compute.forwardingRules.delete",
        "compute.forwardingRules.get",
        "compute.forwardingRules.list",
        "compute.forwardingRules.setLabels",
        "compute.globalOperations.get",
        "compute.images.list",
        "compute.images.useReadOnly",
        "compute.instances.create",
        "compute.instances.delete",
        "compute.instances.get",
        "compute.instances.list",
        "compute.instances.reset",
        "compute.instances.resume",
        "compute.instances.setDeletionProtection",
        "compute.instances.setLabels",
        "compute.instances.setMetadata",
        "compute.instances.setServiceAccount",
        "compute.instances.start",
        "compute.instances.stop",
        "compute.instances.use",
        "compute.machineTypes.get",
        "compute.machineTypes.list",
        "compute.networkEndpointGroups.attachNetworkEndpoints",
        "compute.networkEndpointGroups.create",
        "compute.networkEndpointGroups.delete",
        "compute.networkEndpointGroups.detachNetworkEndpoints",
        "compute.networkEndpointGroups.get",
        "compute.networkEndpointGroups.list",
        "compute.networkEndpointGroups.use",
        "compute.networks.create",
        "compute.networks.delete",
        "compute.networks.get",
        "compute.networks.list",
        "compute.networks.updatePolicy",
        "compute.networks.use",
        "compute.regionBackendServices.create",
        "compute.regionBackendServices.delete",
        "compute.regionBackendServices.get",
        "compute.regionBackendServices.list",
        "compute.regionBackendServices.use",
        "compute.regionOperations.get",
        "compute.regions.get",
        "compute.regions.list",
        "compute.routers.create",
        "compute.routers.delete",
        "compute.routers.get",
        "compute.routers.list",
        "compute.subnetworks.create",
        "compute.subnetworks.delete",
        "compute.subnetworks.get",
        "compute.subnetworks.list",
        "compute.subnetworks.use",
        "compute.zoneOperations.get",
        "compute.zones.get",
        "compute.zones.list",
        "iam.serviceAccounts.actAs",
        "iam.serviceAccounts.get",
        "iam.serviceAccounts.list",
        "resourcemanager.projects.get"
         # Add any additional permissions required for NC2 portal
    ]
}

# Assign the custom role NC2 portal to the service account NC2 Portal
# cf. 
resource "google_project_iam_member" "TF_NC2_Portal_SA_Custom_Role_Binding" {
    project = var.ProjectID
    role    = google_project_iam_custom_role.TF_Custom_Role_NC2_Portal.name
    member  = "serviceAccount:${google_service_account.TF_NC2_Portal_SA.email}"
}

