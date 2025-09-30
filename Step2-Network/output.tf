output "TF_VpnGatewayStaticIp" {
  description = "The static public IP address of the VPN gateway in Google Cloud - to put in the on prem VPN configuration"
  value       = google_compute_address.TF_VpnGatewayStaticIp.address
}