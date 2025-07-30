output "TF_VpnGatewayStaticIp" {
  description = "The static public IP address of the VPN gateway in Google Cloud"
  value       = google_compute_address.TF_VpnGatewayStaticIp.address
}