# This code is compatible with Terraform 4.25.0 and versions that are backwards compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

# Fetch the latest Windows Server 2025 (Desktop Experience) image from the "windows-cloud" project
data "google_compute_image" "terra_jumbox_image" {
  family  = "windows-2025"
  project = "windows-cloud"
}


resource "google_compute_instance" "terra_jumbox_vm" {
  count = var.EnableJumbox
  boot_disk {
    auto_delete = true
    device_name = "windows-jumbox-nc2"

    initialize_params {
      # To get Windows Server 2025 images : gcloud compute images list --project=windows-cloud --filter="name:windows-server-2025"
      # windows-server-2025-dc-v20250813
      # image = "projects/windows-cloud/global/images/windows-server-2025-dc-v20251209"

      # image = data.google_compute_image.terra_jumbox_image.image_id  
      image = data.google_compute_image.terra_jumbox_image.id

      size  = 50
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    usage                 = "jumbox"
  }

  # VM instance type
  # to get the list of available machine types, run:
  # gcloud compute machine-types list --zones="europe-west4-b"
  # cheapest VM size in Google Cloud is the shared-core instance type, particularly the e2-micro and f1-micro that are good for a Linux VM
  # To run Windows Server 2025 on Google Cloud, you generally need at least 2vCPUs and 8GB
  # Cheapest VM for Windows Server are : e2-medium, c4a-standard-2, c4d-standard-2, c4a-highmem-2
  # For more information, see: https://cloud.google.com/compute/docs/machine-types
  machine_type = "e2-medium"

  metadata = {
    enable-osconfig = "TRUE"
  }

  name = "windows-jumbox-stan"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork = google_compute_subnetwork.terra_cluster_management_subnet.id
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = var.VmServiceAccountEmail
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  zone = var.VmZone
}


# Firewall rule for RDP
# cf. https://cloud.google.com/vpc/docs/firewalls#creating_firewall_rules
# cf. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "TF_Allow_RDP" {
  count = var.EnableJumbox
  name    = "allow-rdp"
  network = google_compute_network.terra_custom_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow RDP from any source, you should restrict this in production
}